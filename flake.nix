{
  description = "pmc's Nix system configuration";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  inputs.home-manager.url = github:nix-community/home-manager/master;
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";
  inputs.nix-ld.url = github:Mic92/nix-ld/main;
  inputs.nix-ld.inputs.nixpkgs.follows = "nixpkgs";
  inputs.flake-utils.url = github:numtide/flake-utils;
  inputs.gitignore.url = github:github/gitignore;
  inputs.gitignore.flake = false;
  inputs.nur.url = github:nix-community/NUR;
  inputs.nur.inputs.nixpkgs.follows = "nixpkgs";
  inputs.vscode-server.url = github:msteen/nixos-vscode-server;
  inputs.vscode-server.flake = false;

  outputs = inputs:
    let context = inputs // inputs.self; in
    rec {
      homeConfigurations = import ./homeConfigurations context;
      homeModules = import ./homeModules context;
      nixosConfigurations = import ./nixosConfigurations context;
      nixosModules = import ./nixosModules context;
      packages = import ./packages context;
      overlay = import ./packages/overlay.nix context;
      hydraJobs = let pkgs = import context.nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
        overlays = [ context.overlay ];
      }; in
        {
          packages = pkgs.lib.mapAttrs (name: value: pkgs.${name}) context.packages.x86_64-linux;
          configurations = pkgs.lib.mapAttrs (name: value: value.config.system.build.vm) context.nixosConfigurations;
          installer = context.nixosConfigurations.installer.config.system.build.isoImage;
        };
    };
}
