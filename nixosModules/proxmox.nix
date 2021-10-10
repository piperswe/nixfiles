{ ... }:
{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [
      (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = lib.mkDefault "/dev/disk/by-uuid/cb8f5d4f-bdaa-47db-9be6-1d1e8cb627af";
      fsType = "ext4";
    };

  swapDevices = [ ];

  boot.kernelParams = [
    "console=ttyS0,115200"
    "console=tty1"
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  services.qemuGuest.enable = true;
}
