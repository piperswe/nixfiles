{
  description = "pmc's Nix system configuration";

  inputs = {
    flake-utils = { url = github:numtide/flake-utils; };

    nixpkgs = { url = github:nixos/nixpkgs/nixpkgs-unstable; };

    nixpkgs-master = { url = github:nixos/nixpkgs; };

    nixpkgs-piper-bootstrap = { url = github:piperswe/nixpkgs/piper/bootstrap-ppc64le-and-sparc64; };

    nur = {
      url = github:nix-community/nur;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = github:lnl7/nix-darwin;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hydra = { url = github:nixos/hydra; };

    vscode-server = {
      url = github:msteen/nixos-vscode-server;
      flake = false;
    };

    gitignore = {
      url = github:github/gitignore;
      flake = false;
    };

    fish-theme-sushi = {
      url = github:umayr/theme-sushi;
      flake = false;
    };

    fish-rbenv = {
      url = github:piperswe/fish-rbenv/patch-1;
      flake = false;
    };

    nixos-hardware.url = github:nixos/nixos-hardware;
  };

  outputs = inputs:
    let
      context = inputs // inputs.self // { root = ./.; };
      inherit (context)
        packages
        homeConfigurations
        nixosConfigurations
        overlay overlays
        darwinConfigurations
        flake-utils nixpkgs home-manager nur;
      inherit (context.lib) nixpkgs-for-system supported-platforms;
    in
    {
      lib = import ./lib context;
      homeConfigurations = import ./homeConfigurations context;
      rawHomeConfigurations = import ./homeConfigurations/raw.nix context;
      homeModules = import ./homeModules context;
      nixosConfigurations = import ./nixosConfigurations context;
      nixosModules = import ./nixosModules context;
      darwinConfigurations = import ./darwinConfigurations context;
      darwinModules = import ./darwinModules context;
      packages = import ./packages context;
      devShells = context.packages;
      apps = builtins.listToAttrs (builtins.map
        (system: {
          name = system;
          value = {
            update-machine = flake-utils.lib.mkApp {
              drv = packages.${system}.update-machine;
            };
          };
        })
        supported-platforms.hydra);
      overlay = import ./packages/overlay.nix context;
      overlays = [ nur.overlay overlay ];
      hydraJobs = {
        packages = nixpkgs.lib.mapAttrs
          (system: packages:
            let
              pkgs = import (nixpkgs-for-system system) {
                inherit system overlays;
                config.allowUnfree = true;
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
              "toplevel"

              # # From github:nix-community/nix-generators
              # "amazonImage"
              # "azureImage"
              # "cloudstackImage"
              # "digitalOceanImage"
              # "googleComputeImage"
              # "hypervImage"
              # "isoImage"
              # "kexec_bundle"
              # "kexec_tarball"
              # "metadata"
              # "tarball"
              # "novaImage"
              # "openstackImage"
              # "qcow"
              # "raw"
              # "sdImage"
              # "vagrantVirtualbox"
              # "virtualBoxOVA"
              # "vmwareImage"

              # # Last because all configurations generate this
              # "vm"
            ])
          nixosConfigurations;
        darwinConfigurations = nixpkgs.lib.mapAttrs (name: value: value.system) darwinConfigurations;
        homeConfigurations =
          let
            buildHome = (configuration: system:
              let pkgs = import (nixpkgs-for-system system) {
                inherit system overlays;
                config.allowUnfree = true;
              };
              in
              {
                base = (home-manager.lib.homeManagerConfiguration {
                  inherit configuration system pkgs;
                  homeDirectory = "/home/pmc";
                  username = "pmc";
                }).config.home.activationPackage;
                gui = (home-manager.lib.homeManagerConfiguration {
                  inherit configuration system pkgs;
                  extraModules = [{ withGUI = true; }];
                  homeDirectory = "/home/pmc";
                  username = "pmc";
                }).config.home.activationPackage;
              });
          in
          nixpkgs.lib.mapAttrs
            (name: value:
              (builtins.listToAttrs
                (builtins.map
                  (system: {
                    name = system;
                    value = buildHome value system;
                  })
                  supported-platforms.hydra)))
            homeConfigurations;
        checks = (builtins.listToAttrs
          (builtins.map
            (system: {
              name = system;
              value = import ./checks context system;
            })
            supported-platforms.hydra));
      } // (import ./hydraJobs context);
    };
}
