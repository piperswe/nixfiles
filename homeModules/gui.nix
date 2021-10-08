{ homeModules, ... }:
{ pkgs, config, ... }:
{
  imports = [ homeModules.firefox ];
  home.packages =
    if config.withGUI then with pkgs; [
      tdesktop
      _1password-gui
      plexamp
      steam
      steam-run
      yubioath-desktop
      vscodium
      josm
      vlc
    ] else [ ];
  allowUnfreePackages = [ "1password" "plexamp" "steam" "steam-original" "steam-runtime" ];
}
