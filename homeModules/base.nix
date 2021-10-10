{ homeModules, overlay, nur, ... }:
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
      let
        nonARMv6lPackages = [
          # I work with Nix enough that I want these in my profile
          cachix
        ];
      in
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
        iotop
        bat
        bat-extras.batman
        bat-extras.batgrep
        bat-extras.batdiff
        bat-extras.batwatch
        bat-extras.prettybat
        file
        gh
      ]
      ++ (lib.optionals (!lib.hasPrefix "armv6l-" stdenv.system) nonARMv6lPackages);
  };
}
