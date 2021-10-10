context@{ flake-utils, nixpkgs, ... }:
let
  systems = nixpkgs.lib.systems.supported.hydra;
  packageSystems = builtins.map (system: nixpkgs.lib.nameValuePair system (import ./pkgs.nix nixpkgs.legacyPackages.${system})) systems;
in
builtins.listToAttrs packageSystems
