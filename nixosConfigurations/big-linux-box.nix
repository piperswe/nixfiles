{ nixpkgs, nixosModules, ... }:
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    nixosModules.base
    nixosModules.desktop
    nixosModules.development
    nixosModules.pmc-user
    nixosModules.nvidia
    nixosModules.homebase
    ({ config, lib, pkgs, modulesPath, ... }: {
      imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

      networking.hostName = "big-linux-box";

      boot.loader.systemd-boot.enable = true;
      # boot.loader.grub = {
      #   enable = true;
      #   version = 2;
      #   device = "nodev";
      #   useOSProber = true;
      #   efiSupport = true;
      # };
      boot.loader.efi.canTouchEfiVariables = true;

      boot.initrd.availableKernelModules =
        [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "sg" "kvm-amd" ];
      boot.extraModulePackages = [ ];
      boot.supportedFilesystems = [ "ntfs" ];
      boot.binfmt.emulatedSystems = [ "aarch64-linux" "powerpc64le-linux" "sparc64-linux" ];

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/3357e4c2-a4f3-4d15-b3a0-db2c53415263";
        fsType = "btrfs";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/6635-F978";
        fsType = "vfat";
      };

      fileSystems."/archive" = {
        device = "/dev/disk/by-uuid/3CFA8CA0FA8C5852";
        fsType = "ntfs";
        options = [ "ro" ];
      };

      swapDevices =
        [{ device = "/dev/disk/by-uuid/3d85a7fd-17f3-4b5f-bf24-b449fd6ae08a"; }];

      hardware.video.hidpi.enable = true;

      networking.useDHCP = false;
      networking.interfaces.enp4s0.useDHCP = true;

      time.timeZone = "America/Chicago";

      hmStateVersion = "21.05";
      system.stateVersion = "20.09";
    })
  ];
}
