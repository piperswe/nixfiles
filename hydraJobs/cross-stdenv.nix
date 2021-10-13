{ lib, ... }:
let
  stdenv = system: (import (lib.nixpkgs-for-system system) {
    localSystem = {
      system = "x86_64-linux";
    };
    crossSystem = {
      inherit system;
    };
  }).stdenv;
in
builtins.listToAttrs
  (builtins.map
    (system:
      {
        name = system;
        value = stdenv system;
      }
    )
    lib.supported-platforms.hydra)
