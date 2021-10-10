{ homeModules, ... }:
{ pkgs, lib, config, ... }:
{
  imports = [ homeModules.firefox ];
  options = {
    withGUI = lib.mkEnableOption "GUI";
  };
  config = lib.mkIf config.withGUI {
    home.packages = with pkgs;
      let
        linuxNonARMv6lPackages = [
          tdesktop
        ];
        linuxNonAarch32Packages = [
          vlc
        ];
        x86_64-linuxPackages = [
          _1password-gui
          plexamp
          steam
          steam-run
          yubioath-desktop
        ];
        vscodiumSupported = builtins.elem stdenv.system [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "armv7l-linux" ];
      in
      [
        josm
      ]
      ++ (lib.optionals (stdenv.system == "x86_64-linux") x86_64-linuxPackages)
      ++ (lib.optionals (stdenv.isLinux && stdenv.system != "armv6l-linux") linuxNonARMv6lPackages)
      ++ (lib.optionals (stdenv.isLinux && !stdenv.isAarch32) linuxNonAarch32Packages)
      ++ (lib.optional vscodiumSupported vscodium);
    allowUnfreePackages = [ "1password" "plexamp" "steam" "steam-original" "steam-runtime" ];
  };
}
