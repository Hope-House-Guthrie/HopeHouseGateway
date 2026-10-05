{ inputs, nixosConfiguration, stdenv, ... }:
let
  system = stdenv.hostPlatform.system;
  imagePackage = nixosConfiguration.config.system.build.images.azure;
  imageConfiguration = imagePackage.passthru.config;
in 
inputs.terranix.lib.terranixConfiguration {
  inherit system;

  modules = [
    ./terranix.nix
  ];

  extraArgs = {
    inherit imageConfiguration imagePackage;
  };
}