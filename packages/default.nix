context@{ flake-utils, nixpkgs, ... }:
{
  x86_64-linux = import ./pkgs.nix nixpkgs.legacyPackages.x86_64-linux;
}
