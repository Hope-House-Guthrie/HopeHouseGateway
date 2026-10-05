{
  adminPublicKeys,
  constants,
  inputs,
  secretsPath,
}:
inputs.nixpkgs.lib.nixosSystem {
  specialArgs = {
    inherit
      adminPublicKeys
      constants
      inputs
      secretsPath
      ;
  };

  modules = [
    inputs.agenix.nixosModules.default
    inputs.h2-site.nixosModules.default
    inputs.h3.nixosModules.h3-frontend
    ./configuration.nix
    {
      nixpkgs.overlays = [
        inputs.h2-site.overlays.default
        inputs.h3.overlays.default
      ];
    }
  ];
}
