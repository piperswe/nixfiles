{
  description = "pmc's Nix system configuration";

  inputs = {
    flake-utils = { url = github:numtide/flake-utils; };

    nixpkgs = { url = github:nixos/nixpkgs; };

    nur = {
      url = github:nix-community/nur;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = github:nix-community/home-manager;
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
  };

  outputs = inputs:
    let
      context = inputs // inputs.self // { root = ./.; };
      inherit (context) packages overlay nixpkgs nixosConfigurations homeConfigurations home-manager nur;
    in
    {
      lib = import ./lib context;
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
                overlays = [ nur.overlay overlay ];
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
        homeConfigurations =
          let
            buildHome = (configuration: system:
              let pkgs = import nixpkgs {
                inherit system;
                config.allowUnfree = true;
                overlays = [ nur.overlay overlay ];
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
                  context.lib.supported-platforms.hydra)))
            homeConfigurations;
        checks = (builtins.listToAttrs
          (builtins.map
            (system: {
              name = system;
              value = import ./checks context system;
            })
            context.lib.supported-platforms.hydra));
      };
    };
}
