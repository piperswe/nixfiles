context:
{
  auto-upgrade = import ./auto-upgrade.nix context;
  base = import ./base.nix context;
  buildbox = import ./buildbox.nix context;
  cache = import ./cache.nix context;
  cloudflared = import ./cloudflared.nix context;
  desktop = import ./desktop.nix context;
  development = import ./development.nix context;
  fake-hwclock = import ./fake-hwclock.nix context;
  homebase = import ./homebase.nix context;
  nvidia = import ./nvidia.nix context;
  pi4 = import ./pi4.nix context;
  pmc-user = import ./pmc-user.nix context;
  proxmox = import ./proxmox.nix context;
  ssh = import ./ssh.nix context;
}
