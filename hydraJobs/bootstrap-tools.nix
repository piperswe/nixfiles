{ lib, nixpkgs-piper-bootstrap, ... }:
let
  nixpkgs = nixpkgs-piper-bootstrap;
  tools = system: import "${nixpkgs}/pkgs/stdenv/linux/scratch" { from = "x86_64-linux"; to = system; };
in
builtins.listToAttrs
  (builtins.map
    (system:
      {
        name = system;
        value = tools system;
      }
    )
    (builtins.filter
      (x: (nixpkgs.lib.hasSuffix "-linux" x))
      lib.supported-platforms.hydra))
