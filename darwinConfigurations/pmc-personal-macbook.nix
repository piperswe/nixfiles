{ nixpkgs, darwin, darwinModules, ... }:
darwin.lib.darwinSystem {
  system = "aarch64-darwin";
  modules = [
    darwinModules.base
    darwinModules.pmc-user
    ({ ... }: {
      withGUI = true;
      networking.hostName = "pmc-personal-macbook";
      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;
    })
  ];
}
