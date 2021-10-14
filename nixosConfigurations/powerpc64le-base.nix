{ nixpkgs-piper-bootstrap, nixosModules, ... }:
nixpkgs-piper-bootstrap.lib.nixosSystem {
  system = "powerpc64le-linux";
  modules = [
    ({ config, lib, pkgs, modulesPath, ... }: {
      nixpkgs.localSystem.system = "x86_64-linux";
      nixpkgs.crossSystem.system = "powerpc64le-linux";
      networking.hostName = "powerpc64le-base";
      system.stateVersion = "21.11";
      fileSystems."/" = {
        device = "/dev/sda1";
        fsType = "ext4";
      };
      boot.loader.grub.enable = true;
      boot.loader.grub.version = 2;
      boot.loader.grub.device = "/dev/sda";
      # this pulls in, among other things, a whole cross rustc to build spidermonkey
      security.polkit.enable = false;
    })
  ];
}
