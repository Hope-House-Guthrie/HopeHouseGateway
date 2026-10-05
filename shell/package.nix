{
  constants,
  inputs,
  pkgs,
  stdenv,
  ...
}:
let
  system = stdenv.hostPlatform.system;
  agenix = inputs.agenix.packages.${system}.agenix;
  nixosConfiguration = "h2-gateway";

  update-host = pkgs.writeShellScriptBin "update-host" ''
    set -e
    ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch \
      --flake .#${nixosConfiguration} \
      --sudo \
      --target-host admin@${constants.network.wan.address}
  '';

  provision-host = pkgs.writeShellScriptBin "provision-host" ''
    set -e

    TERRANIX_OUT=$(${pkgs.nix}/bin/nix build .#provisioner --no-link --print-out-paths)

    REPO_ROOT=$(git rev-parse --show-toplevel)
    PROVISION_ROOT="$REPO_ROOT/.provision"
    mkdir -p $PROVISION_ROOT

    cat "$TERRANIX_OUT" > "$PROVISION_ROOT/config.tf.json"

    echo "==> Preparing..."
    ${pkgs.opentofu}/bin/tofu -chdir=$PROVISION_ROOT init 

    echo "==> Provisioning..."
    ${pkgs.opentofu}/bin/tofu -chdir=$PROVISION_ROOT apply "$@"
  '';
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    agenix
    nixd
    nixfmt
    provision-host
    starship
    update-host
  ];

  shellHook = ''
    eval "$(starship init bash)"
  '';
}
