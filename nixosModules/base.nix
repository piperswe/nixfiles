{ nixpkgs, overlay, nur, nixosModules, ... }:
{ pkgs, lib, config, options, modulesPath, ... }: {
  imports = [
    nixosModules.cache
    nixosModules.ssh
    nixosModules.staging
    (modulesPath + "/installer/cd-dvd/channel.nix")
  ];
  options = {
    allowUnfreePackages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
    hmStateVersion = lib.mkOption {
      type = lib.types.str;
      default = "21.05";
    };
    withGUI = lib.mkEnableOption "GUI";
  };
  config = {
    nix = {
      package = pkgs.nixUnstable;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
      registry = {
        nixfiles = {
          from = {
            type = "indirect";
            id = "nixfiles";
          };
          to = {
            type = "github";
            owner = "piperswe";
            repo = "nixfiles";
          };
        };
      };
      nixPath = lib.mkForce [
        "nixpkgs=${nixpkgs}"
      ];
      autoOptimiseStore = true;
      gc = {
        automatic = true;
        dates = "weekly";
      };
    };
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.allowUnfreePackages;
    nixpkgs.overlays = [ overlay nur.overlay ];
    networking.nameservers = [ "::1" ];
    services.dnscrypt-proxy2 = {
      enable = true;
      settings = {
        listen_addresses = [ "[::1]:51" ];
        ipv6_servers = true;
        require_dnssec = true;
        cache = true;

        sources.public-resolvers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          ];
          cache_file = "/var/lib/dnscrypt-proxy/public-resolvers.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        };

        server_names = [
          # Cloudflare
          "cloudflare"
          "cloudflare-ipv6"
        ];
      };
    };
    # Forward loopback traffic on port 53 to dnscrypt-proxy2.
    networking.firewall.extraCommands = ''
      ip6tables --table nat --flush OUTPUT
      ${lib.flip (lib.concatMapStringsSep "\n") [ "udp" "tcp" ] (proto: ''
        ip6tables --table nat --append OUTPUT \
          --protocol ${proto} --destination ::1 --destination-port 53 \
          --jump REDIRECT --to-ports 51
      '')}
    '';
    services.chrony = {
      enable = true;
      servers = [
        # On devices without an RTC, dnscrypt-proxy2 requires the time to download its public resolvers list,
        # but Chrony requires DNS to resolve the NTP server's address. These are the IP addresses of
        # time.cloudflare.com; maybe I'll add a local resolver at some point to get around this.
        "162.159.200.1"
        "162.159.200.123"

        "time.cloudflare.com"
      ];
    };
    programs.command-not-found.enable = true;
    services.ipfs.enable = true;
  };
}
