{ nixpkgs, nixosModules, ... }:
nixpkgs.lib.nixosSystem {
  system = "aarch64-linux";
  modules = [
    nixosModules.base
    nixosModules.pmc-user
    ({ config, lib, pkgs, modulesPath, ... }: {
      imports = [ "${modulesPath}/installer/sd-card/sd-image-aarch64.nix" ];

      networking.hostName = "aarch64-buildbox";

      networking.useDHCP = false;
      networking.interfaces.ens18.useDHCP = true;

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
