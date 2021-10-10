{ homeModules, lib, ... }:
with lib;
{ pkgs, lib, config, ... }:
{
  imports = [ homeModules.firefox ];
  options = {
    withGUI = lib.mkEnableOption "GUI";
  };
  config = lib.mkIf config.withGUI {
    home.packages = with pkgs;
      let
        x86_64-linux = stdenv.system == "x86_64-linux";
      in
      universal-packages
        [
          { compatible = stdenv.isLinux && stdenv.system != "armv6l-linux"; pkg = tdesktop; }
          { compatible = stdenv.isLinux && !stdenv.isAarch32; pkg = vlc; }
          { compatible = x86_64-linux; pkg = _1password-gui; }
          { compatible = x86_64-linux; pkg = plexamp; }
          { compatible = x86_64-linux; pkg = steam; }
          { compatible = x86_64-linux; pkg = steam-run; }
          { compatible = x86_64-linux; pkg = yubioath-desktop; }
          { compatible = builtins.elem stdenv.system [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "armv7l-linux" ]; pkg = vscodium; }
          josm
        ];
    allowUnfreePackages = [ "1password" "plexamp" "steam" "steam-original" "steam-runtime" ];
  };
}
