{ ... }:
{ pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "bastion" = {
        hostname = "bastion.piperswe.me";
        user = "pmc";
      };
      "devbox" = {
        hostname = "192.168.0.235";
        user = "pmc";
        proxyJump = "bastion";
      };
      "utrecht" = {
        hostname = "192.168.0.144";
        user = "pmc";
        proxyJump = "bastion";
      };
      "vm-server-1" = {
        hostname = "192.168.4.2";
        user = "root";
        proxyJump = "bastion";
      };
      "piperswe.me" = {
        hostname = "192.168.4.138";
        user = "pmc";
        proxyJump = "bastion";
      };
      "pleroma.piperswe.me" = {
        hostname = "192.168.4.211";
        user = "pmc";
        proxyJump = "bastion";
      };
      "minecraft.piperswe.me" = {
        hostname = "192.168.4.200";
        user = "pmc";
        proxyJump = "bastion";
      };
      "aarch64-buildbox" = {
        hostname = "192.168.0.132";
        user = "pmc";
        proxyJump = "bastion";
      };
      "hydra" = {
        hostname = "192.168.4.233";
        user = "pmc";
        proxyJump = "bastion";
      };
    };
  };
}
