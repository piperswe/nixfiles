{ fish-theme-sushi, ... }:
{ pkgs, lib, ... }:
{
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "sushi";
        src = fish-theme-sushi;
      }
    ];
    shellInit = ''
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
    '';
  };
}
