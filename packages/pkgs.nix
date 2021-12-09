context:
{ callPackage, lib, stdenv, ... }:
{
  nix-cache-piperswe-me = callPackage ./nix-cache.piperswe.me { };
  update-machine = callPackage ./update-machine { };
  hm-switch = callPackage (import ./hm-switch.nix context) { };
} //
(lib.optionalAttrs stdenv.isLinux
  {
    fake-hwclock = callPackage ./fake-hwclock.nix { };
  })
