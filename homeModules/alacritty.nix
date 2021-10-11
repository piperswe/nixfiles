{ ... }:
{ pkgs, lib, config, ... }:
{
  config = lib.mkIf
    (config.withGUI)
    {
      programs.alacritty = {
        enable = true;
      };
    };
}
