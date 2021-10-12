{ nixpkgs, ... }:
system:
let
  pkgs = nixpkgs.legacyPackages.${system};
in
pkgs.runCommand "nixpkgs-fmt"
{
  flake = ../.;
}
  ''
    echo checking through nixpkgs-fmt:
    files=$(ls $flake/{,**/}*.nix)
    for file in $files
    do
      echo ' - '$file
    done
    ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt --check $files
    echo ok > $out
  ''
