{ nixpkgs, nixosModules, ... }:
# Build ISO with `nix build '.#nixosConfigurations.installer.config.system.build.isoImage'`
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    nixosModules.base
    nixosModules.cache
    nixosModules.pmc-user
    ({ modulesPath, ... }: {
      imports = [
        (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
        (modulesPath + "/profiles/qemu-guest.nix")
      ];
    })
  ];
}
