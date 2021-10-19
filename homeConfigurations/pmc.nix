{ homeModules, ... }:
{ pkgs, lib, ... }:
{
  imports = [
    homeModules.base
  ];
  home.username = lib.mkDefault "pmc";
  home.homeDirectory = lib.mkDefault "/home/pmc";
}
