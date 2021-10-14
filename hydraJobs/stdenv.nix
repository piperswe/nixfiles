{ lib, nixpkgs-piper-bootstrap, ... }:
let
  nixpkgs = nixpkgs-piper-bootstrap;
  pkgs = system: (import "${nixpkgs}/pkgs/stdenv/linux/scratch" { from = "x86_64-linux"; to = system; }).pkgsWithTools;
  stdenv = system: (pkgs system).stdenv;
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
