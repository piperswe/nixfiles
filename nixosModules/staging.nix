# Modules that are in staging to be included in nixpkgs
# These all have enable options, so they can be imported everywhere.

{ nixosModules, ... }:
{
  imports = with nixosModules; [
    cloudflared
    fake-hwclock
  ];
}
