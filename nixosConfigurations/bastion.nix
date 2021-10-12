{ nixpkgs, nixosModules, ... }:
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    nixosModules.base
    nixosModules.proxmox
    nixosModules.pmc-user
    nixosModules.homebase
    nixosModules.auto-upgrade
    ({ config, lib, pkgs, modulesPath, ... }: {
      networking.hostName = "bastion";
      networking.domain = "piperswe.me";

      networking.useDHCP = false;
      networking.interfaces.ens18.useDHCP = true;

      time.timeZone = "America/Chicago";

      services.openssh.enable = true;

      hmStateVersion = "21.11";
      system.stateVersion = "21.11";
    })
  ];
}
