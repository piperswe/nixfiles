{ ... }:
{ ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.driSupport32Bit = true;
  allowUnfreePackages = [ "nvidia-x11" "nvidia-settings" ];
}
