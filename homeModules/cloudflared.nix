{ ... }:
{ pkgs, lib, config, ... }:
{
  config = {
    allowUnfreePackages = [
      "cloudflared"
    ];
    home.packages = [
      pkgs.cloudflared
    ];
  };
}
