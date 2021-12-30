context@{ lib, nixpkgs, rawHomeConfigurations, flake-utils, home-manager, ... }:
let
  systems = lib.supported-platforms.hydra;
  configSystems = builtins.map
    (system:
      nixpkgs.lib.nameValuePair
        system
        (builtins.mapAttrs
          rawHomeConfigurations
          (name: value: home-manager.lib.homeManagerConfiguration {
            inherit system;
            homeDirectory = "/home/${name}";
            username = name;
            configuration = value;
          })))
    systems;
in
builtins.listToAttrs configSystems
