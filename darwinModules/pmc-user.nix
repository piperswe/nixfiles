{ home-manager, homeConfigurations, ... }:
{ pkgs, lib, config, ... }: {
  imports = [ home-manager.darwinModules.home-manager ];
  config = {
    nix.trustedUsers = [ "pmc" ];
    users.users.pmc = {
      name = "pmc";
      home = "/Users/pmc";
      shell = pkgs.fish;
    };
    home-manager.useUserPackages = true;
    home-manager.backupFileExtension = "hm-backup";
    home-manager.users.pmc = {
      imports = [ homeConfigurations.pmc.config ];
      home.stateVersion = config.hmStateVersion;
      withGUI = config.withGUI;
    };
  };
}
