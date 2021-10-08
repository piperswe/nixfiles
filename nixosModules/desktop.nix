{ ... }:
{ pkgs, lib, ... }: {
  services.avahi = {
    enable = true;
    nssmdns = true;
  };
  services.openssh.enable = true;
  services.udev.packages = [ pkgs.yubikey-personalization ];
  hardware.steam-hardware.enable = true;
  allowUnfreePackages = [ "steam-original" ];
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  services.pcscd.enable = true;
  services.printing = {
    enable = true;
    drivers = [ pkgs.epson-escpr2 ];
  };
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5 = { enable = true; };
  withGUI = true;
}
