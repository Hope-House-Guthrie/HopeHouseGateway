{
  adminPublicKeys,
  config,
  lib,
  secretsPath,
  ...
}:
{
  age.secrets.root-passwd = {
    file = "${secretsPath}/root-passwd.age";
    mode = "0400";
  };

  users = {
    mutableUsers = false;

    users.root.hashedPasswordFile = config.age.secrets.root-passwd.path;

    users.admin = {
      isNormalUser = true;
      hashedPassword = "!";
      openssh.authorizedKeys.keys = adminPublicKeys;
      extraGroups = [
        "wheel"
      ];
    };
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  nix.settings.trusted-users = [
    "root"
    "admin"
  ];

  virtualisation.vmVariant = {
    users = {
      users.root = {
        password = lib.mkForce "root";
        hashedPassword = lib.mkForce null;
        hashedPasswordFile = lib.mkForce null;
      };
    };
  };
}
