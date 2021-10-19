{ nixpkgs, darwin, darwinModules, ... }:
darwin.lib.darwinSystem {
  system = "x86_64-darwin";
  modules = [
    darwinModules.base
    darwinModules.pmc-user
    ({ ... }: {
      withGUI = true;
      networking.hostName = "pmc-ladder-macbook";
      home-manager.users.pmc.programs.git.userEmail = "piper@ladderlife.com";
      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;
    })
  ];
}
