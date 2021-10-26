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
          bat-extras.batman
          bat-extras.batgrep
          bat-extras.batdiff
          bat-extras.batwatch
          bat-extras.prettybat
          file
          gh
          openssh
          silver-searcher
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
