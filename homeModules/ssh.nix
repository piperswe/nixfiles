{ ... }:
{ pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
      KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256
      MACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com
      HostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,sk-ssh-ed25519-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-256-cert-v01@openssh.com,rsa-sha2-512,rsa-sha2-512-cert-v01@openssh.com
    '';
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
