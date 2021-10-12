{ ... }:
{ ... }:
{
  users.users.hydra-queue-runner = {
    description = "SSH user for Hydra";
    group = "hydra";
    createHome = true;
    home = "/var/lib/hydra-queue-runner";
    isSystemUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwdbrLJXDY1n34JmD8DvnFANVHWHHOg64tPaz2owomo root@hydra"
    ];
  };

  nix = {
    trustedUsers = [
      "root"
      "hydra-queue-runner"
    ];
    extraOptions = ''
      min-free = ${toString (16 * 1024 * 1024 * 1024)}
      max-free = ${toString (32 * 1024 * 1024 * 1024)}
    '';
  };
}
    