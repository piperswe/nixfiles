{ callPackage, ... }:
{
  cloudflared = callPackage ./cloudflared.nix { };
}
