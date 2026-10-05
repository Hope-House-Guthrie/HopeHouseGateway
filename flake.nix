{
  description = "Hope House Gateway";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";

    h2-site = {
      url = "github:Hope-House-Guthrie/Hope-House-Site/develop";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    h3 = {
      url = "github:Hope-House-Guthrie/HopeHouseHub/develop";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    terranix = {
      url = "github:terranix/terranix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      pkgs = import inputs.nixpkgs {
        inherit system;
      };

      constants = import ./constants.nix;

      shell = pkgs.callPackage ./shell/package.nix {
        inherit constants inputs;
      };

      adminPublicKeys = (import ./secrets.nix).adminPublicKeys;

      secretsPath = ./secrets;

      nixosConfiguration = (import ./nixos/system.nix) {
        inherit
          adminPublicKeys
          constants
          inputs
          secretsPath
          ;
      };
    in
    {
      devShells.${system}.default = shell;

      packages.${system}.provisioner = pkgs.callPackage ./provisioner/package.nix {
        inherit inputs nixosConfiguration;
      };

      nixosConfigurations.h2-gateway = nixosConfiguration;
    };
}
