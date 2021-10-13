context@{ flake-utils, nixpkgs, lib, ... }:
let
  systems = lib.supported-platforms.hydra;
  packageSystems = builtins.map
    (system:
      nixpkgs.lib.nameValuePair
        system
        (import ./pkgs.nix
          (lib.nixpkgs-for-system system).legacyPackages.${system}))
    systems;
in
builtins.listToAttrs packageSystems
