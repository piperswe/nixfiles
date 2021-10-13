{ lib, ... }:
let
  stdenv = system: (lib.nixpkgs-for-system system).legacyPackages.${system}.stdenv;
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
