context@{ flake-utils, nixpkgs, lib, overlays, ... }:
let
  systems = lib.supported-platforms.hydra;
  packageSystems = builtins.map
    (system:
      nixpkgs.lib.nameValuePair
        system
        (import ./pkgs.nix
        context
          (import (lib.nixpkgs-for-system system) {
            inherit overlays;
            localSystem = { inherit system; };
          })))
    systems;
in
builtins.listToAttrs packageSystems
