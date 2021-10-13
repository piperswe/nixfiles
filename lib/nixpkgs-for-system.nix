{ nixpkgs, nixpkgs-piper-bootstrap, ... }:
system:
if system == "powerpc64le-linux" || system == "sparc64-linux"
then nixpkgs-piper-bootstrap
else nixpkgs
