{ callPackage, ... }:
{
  fake-hwclock = callPackage ./fake-hwclock.nix { };
}
