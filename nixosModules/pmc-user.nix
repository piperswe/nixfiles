{ lib, home-manager, rawHomeConfigurations, ... }:
with lib;
{ pkgs, lib, config, ... }: {
  imports = [ home-manager.nixosModules.home-manager ];
  config = {
    nix.trustedUsers = [ "pmc" ];
    users.users.pmc = {
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = [
        "wheel"
        "networkmanager"
        "docker"
        "dialout"
        "cdrom"
        "libvirtd"
      ];
      openssh.authorizedKeys.keys = ssh-keys;
    };
    home-manager.useUserPackages = true;
    home-manager.users.pmc = {
      imports = [ rawHomeConfigurations.pmc ];
      config = {
        home.stateVersion = config.hmStateVersion;
        withGUI = config.withGUI;
      };
    };
  };
}
