{ callPackage, lib, stdenv, ... }:
{
  nix-cache-piperswe-me = callPackage ./nix-cache.piperswe.me { };
} //
(lib.optionalAttrs stdenv.isLinux
  {
    fake-hwclock = callPackage ./fake-hwclock.nix { };
  })
