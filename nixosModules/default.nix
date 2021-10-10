context:
{
  base = import ./base.nix context;
  buildbox = import ./buildbox.nix context;
  cache = import ./cache.nix context;
  cloudflared = import ./cloudflared.nix context;
  desktop = import ./desktop.nix context;
  development = import ./development.nix context;
  nvidia = import ./nvidia.nix context;
  pmc-user = import ./pmc-user.nix context;
  proxmox = import ./proxmox.nix context;
}
