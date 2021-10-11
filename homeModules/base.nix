{ homeModules, overlay, nur, lib, ... }:
with lib;
{ pkgs, lib, config, ... }:
{
  imports = [ homeModules.gui homeModules.zsh homeModules.git homeModules.neovim ];
  options = {
    allowUnfreePackages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };
  config = {
    programs.home-manager.enable = true;
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.allowUnfreePackages;
    nixpkgs.overlays = [ overlay nur.overlay ];
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
        ];
    programs.gpg.enable = true;
  };
}
