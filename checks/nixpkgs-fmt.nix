{ nixpkgs, ... }:
system:
let
  pkgs = nixpkgs.legacyPackages.${system};
in
pkgs.runCommand "nixpkgs-fmt" { } ''
  ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt --check ${../.}{,**/}*.nix
  echo ok > $out
''
