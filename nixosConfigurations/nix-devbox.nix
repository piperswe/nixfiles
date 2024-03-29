{ nixpkgs, nixosModules, ... }:
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    nixosModules.base
    nixosModules.proxmox
    nixosModules.development
    nixosModules.pmc-user
    nixosModules.homebase
    nixosModules.auto-upgrade
    ({ config, lib, pkgs, modulesPath, ... }: {
      networking.hostName = "nix-devbox";
      networking.hostId = "99fff452";

      boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

      fileSystems."/".device = "/dev/disk/by-uuid/86837245-9314-4eda-8c6f-8fa40212a347";

      networking.useDHCP = false;
      networking.interfaces.ens18.useDHCP = true;

      time.timeZone = "America/Chicago";

      services.openssh.enable = true;

      hmStateVersion = "21.05";
      system.stateVersion = "21.05";
    })
  ];
}
