context:
{ pkgs, modulesPath, ... }:
{
  imports = [ "${modulesPath}/installer/sd-card/sd-image-aarch64.nix" ];

  boot = {
    kernelPackages = pkgs.linuxPackages_rpi4;
    tmpOnTmpfs = true;
    initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
    loader.raspberryPi = {
      enable = true;
      version = 4;
    };
  };

  hardware.enableRedistributableFirmware = true;

  networking.networkmanager.enable = true;

  powerManagement.cpuFreqGovernor = "ondemand";
}
