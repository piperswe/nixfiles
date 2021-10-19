{ nixpkgs, ... }:
{ lib, pkgs, ... }:
{
  options = {
    allowUnfreePackages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
    hmStateVersion = lib.mkOption {
      type = lib.types.str;
      default = "21.05";
    };
    withGUI = lib.mkEnableOption "GUI";
  };
  config = {
    services.nix-daemon.enable = true;
    nix = {
      package = pkgs.nixUnstable;
      extraOptions = ''
        auto-optimise-store = true
        experimental-features = nix-command flakes
      '';
      registry = {
        nixfiles = {
          from = {
            type = "indirect";
            id = "nixfiles";
          };
          to = {
            type = "github";
            owner = "piperswe";
            repo = "nixfiles";
          };
        };
      };
      nixPath = lib.mkForce [
        "nixpkgs=${nixpkgs}"
      ];
      gc = {
        automatic = true;
      };
    };
    users.nix.configureBuildUsers = true;

    programs.bash.enable = true;
    programs.zsh.enable = true;
    programs.fish.enable = true;
  };
}
