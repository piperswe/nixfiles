context:
{ pkgs, lib, modulesPath, ... }:
{
  imports = [ "${modulesPath}/installer/sd-card/sd-image-aarch64.nix" ];

  sdImage.compressImage = false;

  boot = {
    kernelPackages = pkgs.linuxPackages_rpi4;
    tmpOnTmpfs = true;
    initrd.availableKernelModules = lib.mkForce [
      "uas"
      "sdhci_pci"
      "simplefb"
      "vc4"
      "pcie-brcmstb"
      "xhci-pci-renesas"
      "usbhid"
      "usb_storage"
      "md_mod"
      "raid0"
      "raid1"
      "raid10"
      "raid456"
      "ext2"
      "ext4"
      "ahci"
      "sata_nv"
      "sata_via"
      "sata_sis"
      "sata_uli"
      "ata_piix"
      "pata_marvell"
      "sd_mod"
      "sr_mod"
      "mmc_block"
      "uhci_hcd"
      "ehci_hcd"
      "ehci_pci"
      "ohci_hcd"
      "ohci_pci"
      "xhci_hcd"
      "xhci_pci"
      "usbhid"
      "hid_generic"
      "hid_lenovo"
      "hid_apple"
      "hid_roccat"
      "hid_logitech_hidpp"
      "hid_logitech_dj"
      "hid_microsoft"
    ];
    loader.raspberryPi = {
      enable = true;
      version = 4;
    };
  };

  hardware.enableRedistributableFirmware = true;

  networking.networkmanager.enable = true;

  powerManagement.cpuFreqGovernor = "ondemand";
}
