pkgs@{ lib, stdenv, ... }:
lib.optionalAttrs (stdenv.system == "x86_64-linux")
{
  plexamp = pkgs.callPackage ./plexamp.nix { };
}
