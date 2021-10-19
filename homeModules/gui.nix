{ homeModules, nixpkgs-master, lib, ... }:
with lib;
{ pkgs, lib, config, ... }:
let
  pkgsMaster = import nixpkgs-master {
    system = pkgs.stdenv.system;
    config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "plexamp" ];
  };
in
{
  imports = [ homeModules.firefox homeModules.alacritty ];
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
          { compatible = x86_64-linux; pkg = tdesktop; }
          { compatible = stdenv.isLinux && !stdenv.isAarch32; pkg = vlc; }
          { compatible = x86_64-linux; pkg = _1password-gui; }
          { compatible = x86_64-linux; pkg = pkgsMaster.plexamp; }
          { compatible = x86_64-linux; pkg = steam; }
          { compatible = x86_64-linux; pkg = steam-run; }
          { compatible = x86_64-linux; pkg = yubioath-desktop; }
          { compatible = builtins.elem stdenv.system [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "armv7l-linux" ]; pkg = vscodium; }
          { compatible = stdenv.isLinux; pkg = openrgb; }
          { compatible = builtins.elem stdenv.system [ "x86_64-darwin" "x86_64-linux" "i686-linux" "aarch64-linux" "aarch64-darwin" ]; pkg = element-desktop; }
          { compatible = stdenv.isLinux; pkg = virt-manager; }
          { compatible = builtins.elem stdenv.system [ "i686-linux" "x86_64-linux" ]; pkg = jetbrains.idea-ultimate; }
          josm
        ];
    allowUnfreePackages = [ "1password" "plexamp" "steam" "steam-original" "steam-runtime" "idea-ultimate" ];
  };
}
