{ nixpkgs, nixosModules, ... }:
nixpkgs.lib.nixosSystem {
  system = "aarch64-linux";
  modules = [
    nixosModules.base
    nixosModules.pmc-user
    nixosModules.buildbox
    nixosModules.pi4
    nixosModules.homebase
    nixosModules.auto-upgrade
    ({ config, lib, pkgs, modulesPath, ... }: {
      networking.hostName = "aarch64-buildbox";

      time.timeZone = "America/Chicago";

      services.openssh.enable = true;

      nix.extraOptions = ''
        extra-platforms = armv6l-linux armv7l-linux
      '';

      hmStateVersion = "21.05";
      system.stateVersion = "21.05";
    })
  ];
}
