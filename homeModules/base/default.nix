{ homeModules, overlays, lib, ... }:
with lib;
{ pkgs, lib, config, ... }:
{
  imports = [
    homeModules.gui
    homeModules.zsh
    homeModules.fish
    homeModules.git
    homeModules.neovim
    homeModules.ssh
    homeModules.emacs
  ];
  options = {
    allowUnfreePackages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };
  config = {
    programs.home-manager.enable = true;
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.allowUnfreePackages;
    nixpkgs.overlays = overlays;
    home.packages = with pkgs;
      universal-packages
        [
          # I work with Nix enough that I want these in my profile
          nixpkgs-fmt
          rnix-lsp

          # Used for working with my S3 binary cache
          awscli2

          # These are universally usable system utilities
          ripgrep
          wget
          htop
          { compatible = stdenv.isLinux; pkg = iotop; }
          bat
          file
          gh
          openssh
          silver-searcher

          # Development tools I want globally
          nodejs-16_x
          nodePackages.pnpm

          # Allow me to start a shell with Homebrew stuff in the environment
          {
            compatible = stdenv.isDarwin;
            pkg = writeShellScriptBin "brew-shell" ''
              export PATH="/opt/homebrew/bin:$PATH"
              export IN_NIX_SHELL="Sure, whatever"
              export ANY_NIX_SHELL_PKGS="Homebrew"
              exec ''${XDG_CONFIG_HOME:-$HOME/.config}/shell "$@"
            '';
          }
        ];
    programs.gpg.enable = true;
    xdg.configFile."shell" = {
      executable = true;
      text = ''
        #!/bin/sh
        exec ${pkgs.fish}/bin/fish "$@"
      '';
    };
  };
}
