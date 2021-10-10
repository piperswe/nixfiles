{ homeModules, ... }:
{ pkgs, lib, config, ... }:
{
  imports = [ homeModules.firefox ];
  options = {
    withGUI = lib.mkEnableOption "GUI";
  };
  config = lib.mkIf config.withGUI {
    home.packages = with pkgs; [
      tdesktop
      _1password-gui
      plexamp
      steam
      steam-run
      yubioath-desktop
      vscodium
      josm
      vlc
    ];
    allowUnfreePackages = [ "1password" "plexamp" "steam" "steam-original" "steam-runtime" ];
  };
}
