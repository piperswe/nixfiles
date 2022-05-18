{ nixpkgs, nixpkgs-master, nixosModules, hydra, lib, ... }:
with lib;
let
  pkgsMaster = import nixpkgs-master {
    system = "x86_64-linux";
    config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [ "cloudflared" ];
  };
in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    nixosModules.base
    nixosModules.proxmox
    nixosModules.pmc-user
    nixosModules.buildbox
    nixosModules.homebase
    nixosModules.auto-upgrade
    ({ config, lib, pkgs, modulesPath, ... }:
      let
        narCache = "/var/cache/hydra/nar-cache";
        # Systems I have a buildbox for
        nativeSystems = [
          "x86_64-linux"
          "i686-linux"
          "aarch64-linux"
          "armv6l-linux"
          "armv7l-linux"
        ];
        # Linux-based systems I don't have a buildbox for, so should be emulated
        emulatedSystems = lib.filter
          (x:
            (lib.hasSuffix "-linux" x) &&
            !(builtins.elem x nativeSystems))
          supported-platforms.hydra;
      in
      {
        networking.hostName = "hydra";
        networking.domain = "piperswe.me";
        networking.hostId = "e910a73a";

        boot.binfmt.emulatedSystems = emulatedSystems;

        networking.useDHCP = false;
        networking.interfaces.ens18.useDHCP = true;

        time.timeZone = "America/Chicago";

        services.openssh.enable = true;

	services.postgresql.package = pkgs.postgresql_13;

        services.hydra = {
          enable = true;
          package = hydra.defaultPackage.${pkgs.stdenv.system}.overrideAttrs (oldAttrs: {
	    doCheck = false;
	  });
          hydraURL = "http://localhost:3000";
          notificationSender = "hydra@piperswe.me";
          extraConfig = ''
            store_uri = s3://nix-cache?secret-key=/var/lib/hydra/queue-runner/keys/nix-cache.piperswe.me/secret&write-nar-listing=1&ls-compression=br&log-compression=br&compression=br&parallel-compression=1&endpoint=https://1c495e64ff5fd527342d7b7bf6731a1f.r2.cloudflarestorage.com
	    binary_cache_secret_key_file = /var/lib/hydra/queue-runner/keys/nix-cache.piperswe.me/secret
            server_store_uri = https://nix-cache.piperswe.me?local-nar-cache=${narCache}
            binary_cache_public_uri = https://nix-cache.piperswe.me
            upload_logs_to_binary_cache = true
            max_output_size = 17179869184
            compress_num_threads = 8
          '';
          useSubstitutes = true;
        };

        nix.distributedBuilds = true;
        nix.buildMachines = [
          {
            hostName = "localhost";
            systems = emulatedSystems ++ [ "builtin" "x86_64-linux" "i686-linux" ];
            supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
            maxJobs = 10;
            sshKey = "/var/lib/hydra/queue-runner/.ssh/id_ed25519";
            sshUser = "hydra-remote-queue-runner";
          }
          {
            hostName = "aarch64-buildbox";
            systems = [ "aarch64-linux" "armv7l-linux" "armv6l-linux" ];
            supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
            maxJobs = 6;
            sshKey = "/var/lib/hydra/queue-runner/.ssh/id_ed25519";
            sshUser = "hydra-remote-queue-runner";
          }
          # {
          #   hostName = "big-linux-box";
          #   systems = [ "builtin" "x86_64-linux" "i686-linux" "powerpc64le-linux" "sparc64-linux" ];
          #   supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
          #   maxJobs = 15;
          #   sshKey = "/var/lib/hydra/queue-runner/.ssh/id_ed25519";
          #   sshUser = "hydra-remote-queue-runner";
          # }
          # {
          #   hostName = "nixbuild";
          #   system = "x86_64-linux";
          #   maxJobs = 100;
          #   supportedFeatures = [ "benchmark" "big-parallel" ];
          #   sshKey = "/var/lib/hydra/queue-runner/.ssh/id_ed25519";
          # }
        ];

        programs.ssh.extraConfig = lib.mkAfter ''
          Host aarch64-buildbox
            Hostname 192.168.0.132

          Host big-linux-box
            Hostname 192.168.0.224

          Host nixbuild
            Hostname eu.nixbuild.net
        '';

        services.openssh.knownHosts = {
          localhost = {
            hostNames = [ "localhost" ];
            publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMjRgMGJ/zwACrZJZ5f3VIg/qEEde4lhRyC8mf5IRpbs";
          };
          aarch64-buildbox = {
            hostNames = [ "192.168.0.132" "aarch64-buildbox" ];
            publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMI7Y4XN3/uZqK8S4koYh+9jVevTkOhTY6efQ6JNgroe";
          };
          big-linux-box = {
            hostNames = [ "192.168.0.224" "big-linux-box" ];
            publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKOLUxNMJpJkDluWHybOQIhuWCLxw3W+eHBZm9BL2iyE";
          };
          nixbuild = {
            hostNames = [ "eu.nixbuild.net" "nixbuild" ];
            publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
          };
        };

        services.cloudflared = {
          enable = true;
          package = pkgsMaster.cloudflared;
          config = {
            url = "http://localhost:3000";
            tunnel = "505c8dd1-e4fb-4ea4-b909-26b8f61ceaaf";
            credentials-file = "/var/lib/cloudflared/505c8dd1-e4fb-4ea4-b909-26b8f61ceaaf.json";
          };
        };
        allowUnfreePackages = [ "cloudflared" ];

        systemd.tmpfiles.rules =
          [
            "d /var/cache/hydra 0755 hydra hydra -  -"
            "d ${narCache}      0775 hydra hydra 1d -"
          ];

        swapDevices = [
          {
            device = "/dev/disk/by-uuid/3bcb41ac-29f0-4853-8673-8288f5923c5f";
          }
        ];

        hmStateVersion = "21.05";
        system.stateVersion = "21.05";
      })
  ];
}
