{ nixpkgs, nixosModules, hydra, lib, ... }:
with lib;
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    nixosModules.base
    nixosModules.proxmox
    nixosModules.pmc-user
    nixosModules.cloudflared
    nixosModules.buildbox
    ({ config, lib, pkgs, modulesPath, ... }:
      let
        narCache = "/var/cache/hydra/nar-cache";
        # Systems I have a buildbox for
        nativeSystems = [
          "x86_64-linux"
          "i386-linux"
          # "aarch64-linux"
          # "armv6l-linux"
          # "armv7l-linux"
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

        boot.binfmt.emulatedSystems = emulatedSystems;

        networking.useDHCP = false;
        networking.interfaces.ens18.useDHCP = true;

        time.timeZone = "America/Chicago";

        services.openssh.enable = true;

        services.hydra = {
          enable = true;
          package = hydra.defaultPackage.${pkgs.stdenv.system};
          hydraURL = "http://localhost:3000";
          notificationSender = "hydra@piperswe.me";
          extraConfig = ''
            store_uri = s3://nix-cache.piperswe.me?secret-key=/var/lib/hydra/queue-runner/keys/nix-cache.piperswe.me/secret&write-nar-listing=1&ls-compression=br&log-compression=br
            server_store_uri = https://nix-cache.piperswe.me?local-nar-cache=${narCache}
            binary_cache_public_uri = https://nix-cache.piperswe.me
            upload_logs_to_binary_cache = true
            max_output_size = 17179869184
          '';
          useSubstitutes = true;
        };

        nix.buildMachines = [
          {
            hostName = "localhost";
            systems = emulatedSystems ++ [ "builtin" "x86_64-linux" "i386-linux" ];
            supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
            maxJobs = 4;
          }
          # {
          #   hostName = "aarch64-buildbox";
          #   systems = [ "aarch64-linux" "armv7l-linux" "armv6l-linux" ];
          #   supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
          #   maxJobs = 4;
          # }
        ];

        # programs.ssh.extraConfig = lib.mkAfter ''
        #   Host aarch64-buildbox
        #   Hostname 192.168.0.0
        #   Port 22
        #   Compression yes
        # '';

        # services.openssh.knownHosts = [
        #   # aarch64-buildbox
        #   { hostNames = [ "192.168.0.0" ]; publicKey = ""; }
        # ];

        services.cloudflared = {
          enable = true;
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

        hmStateVersion = "21.05";
        system.stateVersion = "21.05";
      })
  ];
}
