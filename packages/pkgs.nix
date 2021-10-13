{ callPackage, lib, stdenv, ... }:
lib.optionalAttrs stdenv.isLinux
{
  fake-hwclock = callPackage ./fake-hwclock.nix { };
}
