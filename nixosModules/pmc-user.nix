{ home-manager, homeConfigurations, ... }:
{ pkgs, lib, config, ... }: {
  imports = [ home-manager.nixosModules.home-manager ];
  config = {
    nix.trustedUsers = [ "pmc" ];
    users.users.pmc = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [
        "wheel"
        "networkmanager"
        "docker"
        "dialout"
        "cdrom"
      ];
    };
    home-manager.useUserPackages = true;
    home-manager.users.pmc = {
      imports = [ homeConfigurations.pmc ];
      home.stateVersion = config.hmStateVersion;
      withGUI = config.withGUI;
    };
  };
}
