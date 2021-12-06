context@{ home-manager, ... }:
{
  pmc = home-manager.lib.homeManagerConfiguration {
    system = "x86_64-linux";
    homeDirectory = "/home/pmc";
    username = "pmc";
    configuration = import ./pmc.nix context;
  };
}
