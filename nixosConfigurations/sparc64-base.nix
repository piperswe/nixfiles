{ nixpkgs-piper-bootstrap, nixosModules, ... }:
nixpkgs-piper-bootstrap.lib.nixosSystem {
  system = "sparc64-linux";
  modules = [
    ({ config, lib, pkgs, modulesPath, ... }: {
      nixpkgs.localSystem.system = "x86_64-linux";
      nixpkgs.crossSystem.system = "sparc64-linux";
      networking.hostName = "sparc64-base";
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
