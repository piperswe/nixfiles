{ callPackage, lib, stdenv, ... }:
{
  nix-cache-piperswe-me = callPackage ./nix-cache.piperswe.me { };
  update-machine = callPackage ./update-machine { };
} //
(lib.optionalAttrs stdenv.isLinux
  {
    fake-hwclock = callPackage ./fake-hwclock.nix { };
  })
