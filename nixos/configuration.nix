{
  imports = [
    ./hardware-configuration.nix
    ./modules/nix.nix
    ./modules/ssh.nix
    ./modules/users.nix
    ./modules/services/caddy.nix
    ./modules/services/h2-site.nix
    ./modules/services/h3-forms.nix
    ./modules/services/h3-frontend.nix
  ];

  i18n.defaultLocale = "en_US.UTF-8";
  networking.hostName = "h2-gateway";
  system.stateVersion = "26.05";

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # todo: move probably

  virtualisation.vmVariant = {
    virtualisation.diskSize = 20480;
    virtualisation.memorySize = 4096;
  };
}
