context@{ flake-utils, nixpkgs, lib, ... }:
let
  systems = lib.supported-platforms.hydra;
  packageSystems = builtins.map (system: nixpkgs.lib.nameValuePair system (import ./pkgs.nix nixpkgs.legacyPackages.${system})) systems;
in
builtins.listToAttrs packageSystems
