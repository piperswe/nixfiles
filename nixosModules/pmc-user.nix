{ home-manager, homeConfigurations, ... }:
{ pkgs, lib, config, ... }: {
  imports = [ home-manager.nixosModules.home-manager ];
  config = {
    nix.trustedUsers = [ "pmc" ];
    users.users.pmc = {
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = [
        "wheel"
        "networkmanager"
        "docker"
        "dialout"
        "cdrom"
        "libvirtd"
      ];
      openssh.authorizedKeys.keys = lib.splitString "\n" ''
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOkkzYtxgVvrjovZfZK/thBFKAdk50ZTv1DRKxh49twr
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDgMQLARpCeoFC/wqCKFl11PlYP9+QkUA3TMKzvBXeD+
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICjhyddU0PuvY1vO3LYFcVjQhZpkQXskMJcK1/x/aP7D
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICqehq8n8i+lCE0hmDLdNBFwnJPXcXpMXJR7HKKdYh5+
        ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAqMv0Afbi+Rkjn5k8GiBiWoFW2UBS4pNbCKZLig3ZRczGAUEj5+PZg73o4DGMYNo457ovCMpybmQACwTWpCbtUNf8sGbb0WQYwMMIhr9ICya35Lmn+SOh4mJEd2rQ/nbtjjJaNcquq5LZKnI5XHB4igIodhH5eLUnANjroCKDV2IjjFYhAOBMy5Y8uZLJ/rgXSDVOfpByWS7LWfVMrSFE71uaKAOcV6+tsC2FTM4QBNC/0mfvF9xf0M0pbPuabSmPKyJlrFy5YxgPzncjpjNqgXqYvjEKqm0ADJsA1i6KvqO09OcQHPPfvaoHlh98n30RMNAxRp/tUAPh/qUQF62REw==
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE7LyR4SS2CcClQaWLtuiR6KgGrhCdAfgNqyVRxQMVya
        sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIHWLz6U9R37w/DWBCmQQGcz44EzPdZWaSdtq3T3k5NylAAAABHNzaDo=
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOzS3BesDb+4eeJKdEgej7+ndi8xtZGDjtdezaUuyZdE
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID/qPGLs4i9XA7gJEiSQI/EQXcYt7Tly0e0SNmUeFX+p
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJeiA+jFQS9IpBlGnqull+9oe7ynwFdWVezc47r3FR5w
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGEDhc/Gmb2520qy0YvIlzdxvihdeKR85p8gfo3ZX6UW
      '';
    };
    home-manager.useUserPackages = true;
    home-manager.users.pmc = {
      imports = [ homeConfigurations.pmc ];
      home.stateVersion = config.hmStateVersion;
      withGUI = config.withGUI;
    };
  };
}
