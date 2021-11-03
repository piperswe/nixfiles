{ fish-theme-sushi, fish-rbenv, ... }:
{ pkgs, lib, ... }:
{
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "sushi";
        src = fish-theme-sushi;
      }
      {
        name = "fish-rbenv";
        src = fish-rbenv;
      }
    ];
    shellInit = ''
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
      ${lib.optionalString pkgs.stdenv.isDarwin "ulimit -n 10240"}
    '';
  };
}
