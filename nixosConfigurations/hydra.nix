{ nixpkgs, nixosModules, ... }:
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    nixosModules.base
    nixosModules.proxmox
    nixosModules.development
    nixosModules.pmc-user
    nixosModules.cloudflared
    ({ config, lib, pkgs, modulesPath, ... }:
      let
        narCache = "/var/cache/hydra/nar-cache";
      in
      {
        networking.hostName = "hydra";
        networking.domain = "piperswe.me";

        boot.binfmt.emulatedSystems =
          lib.filter
            (x:
              (lib.hasSuffix "-linux" x) &&
              !(lib.hasPrefix "x86_64-" x) &&
              !(lib.hasPrefix "i386-" x))
            lib.systems.supported.hydra;

        networking.useDHCP = false;
        networking.interfaces.ens18.useDHCP = true;

        time.timeZone = "America/Chicago";

        services.openssh.enable = true;

        services.hydra = {
          enable = true;
          hydraURL = "http://localhost:3000";
          notificationSender = "hydra@piperswe.me";
          extraConfig = ''
            store_uri = s3://nix-cache.piperswe.me?secret-key=/var/lib/hydra/queue-runner/keys/nix-cache.piperswe.me/secret&write-nar-listing=1&ls-compression=br&log-compression=br
            server_store_uri = https://nix-cache.piperswe.me?local-nar-cache=${narCache}
            binary_cache_public_uri = https://nix-cache.piperswe.me
            upload_logs_to_binary_cache = true
          '';
        };

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

        users.extraUsers.hydra.home = lib.mkForce "/home/hydra";

        hmStateVersion = "21.05";
        system.stateVersion = "21.05";
      })
  ];
}
