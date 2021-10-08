{ homeModules, ... }:
{ pkgs, ... }:
{
  imports = [
    homeModules.base
  ];
  home.username = "pmc";
  home.homeDirectory = "/home/pmc";
}
