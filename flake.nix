{
  description = "pmc's Nix system configuration";

  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  inputs.home-manager.url = github:nix-community/home-manager;
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";
  inputs.nix-ld.url = github:Mic92/nix-ld;
  inputs.nix-ld.inputs.nixpkgs.follows = "nixpkgs";
  inputs.flake-utils.url = github:numtide/flake-utils;
  inputs.gitignore.url = github:github/gitignore;
  inputs.gitignore.flake = false;
  inputs.nur.url = github:nix-community/NUR;
  inputs.nur.inputs.nixpkgs.follows = "nixpkgs";
  inputs.vscode-server.url = github:msteen/nixos-vscode-server;
  inputs.vscode-server.flake = false;
  inputs.hydra.url = github:nixos/hydra;

  outputs = inputs:
    let
      context = inputs // inputs.self;
      inherit (context) packages overlay nixpkgs nixosConfigurations homeConfigurations home-manager;
      inherit (nixpkgs) lib;
    in
    {
      homeConfigurations = import ./homeConfigurations context;
      homeModules = import ./homeModules context;
      nixosConfigurations = import ./nixosConfigurations context;
      nixosModules = import ./nixosModules context;
      packages = import ./packages context;
      overlay = import ./packages/overlay.nix context;
      hydraJobs = {
        packages = nixpkgs.lib.mapAttrs
          (system: packages:
            let
              pkgs = import nixpkgs {
                inherit system;
                config.allowUnfree = true;
                overlays = [ overlay ];
              };
            in
            nixpkgs.lib.mapAttrs (packageName: package: pkgs.${packageName}) packages)
          packages;
        nixosConfigurations = nixpkgs.lib.mapAttrs
          (name: value:
            let
              inherit (value.config.system) build;
              getFallbacks = (fallbacks:
                let
                  attr = builtins.head fallbacks;
                in
                if fallbacks == [ ]
                then { }
                else if build ? ${attr}
                then build.${attr}
                else getFallbacks (builtins.tail fallbacks));
            in
            getFallbacks [
              # From github:nix-community/nix-generators
              "amazonImage"
              "azureImage"
              "cloudstackImage"
              "digitalOceanImage"
              "googleComputeImage"
              "hypervImage"
              "isoImage"
              "kexec_bundle"
              "kexec_tarball"
              "metadata"
              "tarball"
              "novaImage"
              "openstackImage"
              "qcow"
              "raw"
              "sdImage"
              "vagrantVirtualbox"
              "virtualBoxOVA"
              "vmwareImage"

              # Last because all configurations generate this
              "vm"
            ])
          nixosConfigurations;
        installer = nixosConfigurations.installer.config.system.build.isoImage;
        homeConfigurations =
          let
            buildHome = (configuration: system:
              let pkgs = import nixpkgs {
                inherit system;
                config.allowUnfree = true;
                overlays = [ overlay ];
              };
              in
              {
                base = (home-manager.lib.homeManagerConfiguration {
                  inherit configuration system pkgs;
                  homeDirectory = "/home/pmc";
                  username = "pmc";
                }).config.home.activationPackage;
              });
          in
          context.nixpkgs.lib.mapAttrs
            (name: value:
              {
                x86_64-linux = buildHome value "x86_64-linux";
                aarch64-linux = buildHome value "aarch64-linux";
                x86_64-darwin = buildHome value "x86_64-darwin";
                aarch64-darwin = buildHome value "aarch64-darwin";
              })
            homeConfigurations;
      };
    };
}
