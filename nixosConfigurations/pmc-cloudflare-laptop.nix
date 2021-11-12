{ nixpkgs, nixosModules, nixos-hardware, ... }:
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    nixosModules.base
    nixosModules.desktop
    nixosModules.development
    nixosModules.pmc-user
    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-pc-laptop
    nixos-hardware.nixosModules.common-pc-laptop-ssd
    ({ config, lib, pkgs, modulesPath, ... }: {
      imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

      networking.hostName = "pmc-cloudflare-laptop";
      networking.hostId = "fba85db3";

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      fileSystems."/" = {
        device = "/dev/disk/by-label/TODO";
        fsType = "zfs";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-label/TODO";
        fsType = "vfat";
      };

      swapDevices = [{ device = "/dev/disk/by-label/TODO"; }];

      hardware.video.hidpi.enable = true;

      networking.networkmanager.enable = true;

      time.timeZone = "America/Chicago";

      hmStateVersion = "21.11";
      system.stateVersion = "21.11";
    })
  ];
}
