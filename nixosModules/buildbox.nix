{ ... }:
{ lib, config, ... }:
{
  users.groups.hydra = { };
  users.users.hydra-remote-queue-runner = {
    isNormalUser = true;
    group = "hydra";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwdbrLJXDY1n34JmD8DvnFANVHWHHOg64tPaz2owomo root@hydra"
    ];
  };

  nix = {
    trustedUsers = [
      "root"
      "hydra-queue-runner"
      "hydra-remote-queue-runner"
    ];
  };
}
    