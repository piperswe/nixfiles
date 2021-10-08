{ nixpkgs, nixosModules, ... }:
# Build ISO with `nix build '.#nixosConfigurations.installer.config.system.build.isoImage'`
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    nixosModules.base
    nixosModules.cache
    ({ modulesPath, ... }: {
      imports = [
        (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
        (modulesPath + "/installer/cd-dvd/channel.nix")
        (modulesPath + "/profiles/qemu-guest.nix")
      ];
    })
  ];
}
