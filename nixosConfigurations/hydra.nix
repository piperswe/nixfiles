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
            store_uri = s3://nix-cache.piperswe.me?secret-key=/var/lib/hydra/queue-runner/keys/nix-cache.piperswe.me/secret&write-nar-listing=1&ls-compression=xz&log-compression=xz&compression=xz&parallel-compression=1
            server_store_uri = https://nix-cache.piperswe.me?local-nar-cache=${narCache}
            binary_cache_public_uri = https://nix-cache.piperswe.me
            upload_logs_to_binary_cache = true
            max_output_size = 17179869184
            compress_num_threads = 8
            evaluator_workers = 8
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
          {
            hostName = "aarch64-buildbox";
            systems = [ "aarch64-linux" "armv7l-linux" "armv6l-linux" ];
            supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
            maxJobs = 4;
          }
        ];

        programs.ssh.extraConfig = lib.mkAfter ''
          Host aarch64-buildbox
          Hostname 192.168.0.132
          Port 22
        '';

        services.openssh.knownHosts = [
          # aarch64-buildbox
          { hostNames = [ "192.168.0.132" "aarch64-buildbox" ]; publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMI7Y4XN3/uZqK8S4koYh+9jVevTkOhTY6efQ6JNgroe"; }
          { hostNames = [ "192.168.0.132" "aarch64-buildbox" ]; publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC1fjlKjXNqlWHYCraEs9Ktwrn/FKNAZYk8O42Bn8fAMsOj3Hbliml69qdeNW7yYTafcTkOHa1ApEdzP3HYwQgnxXW0IU1MWDQ+cxgah84bI99qskxK4fFjFHOacjhnsNNpdUZlYwvpaUN+SKl66LEt42eRUbQxlGPpYsxtyU+w0axccea8Qe98404n+X4wQfk/ijBiZi7HdM/6dFh/vWPm+SxMCS1bWp5VoOpHXjZ9GdAXmA/U2YRIICBFIHZvGzUN7JNuctTi0pVxr/kmfbvZ0azgEc5wqSxt3kPj/Q+7Hsi/FT/J5H+g3qddfonkPJO/+1HdNLVRNBIUCDCvEoHbtF9TH87pvtKGzLQ+099gIO98nx1aJPNtzzuEfKLfYxOlFLy9VTJJ+o2LHF0zlx3cJn4+LEiinhIe82BKZqs9FzkRgaZ+dZknOOergUnSBu0YR2KrgtpI7TcGiPIynbMTPgB4iqPyK7S2mpY0LXBmoyxNQbbDf04D1yU8mWlr3jdxr1ST5hy/DNmyRnSpc8NA5a4VTcDYTxE6C8BOCmELPH7lmIK5Wz7l0UNRXW6z+vFzObyOf2ohHJ8Js01S1x5f7Cz6TzPHVHKdHu7FHWXjnaT3QjpTQg5LMO3DxGpfuQ6u/VWlbn0xeuWoGg7lj9wxx+8KAJzBHE2Js+wPKfo8ew=="; }
        ];

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
