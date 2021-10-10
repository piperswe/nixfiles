{ ... }:
{ pkgs, lib, config, ... }:
{
  options = {
    services.cloudflared = {
      enable = lib.mkEnableOption "cloudflared";
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.cloudflared;
      };
      config = lib.mkOption {
        type = lib.types.attrs;
        description = "Contents of the config.yaml as an attrset";
      };
    };
  };

  config = lib.mkIf config.services.cloudflared.enable (
    let
      cfg = config.services.cloudflared;
      configFile = pkgs.writeTextFile {
        name = "cloudflared-config.yaml";
        text = builtins.toJSON cfg.config;
      };
    in
    {
      systemd.services.cloudflared = {
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        description = "Cloudflare Argo Tunnel";
        serviceConfig = {
          TimeoutStartSec = 0;
          Type = "notify";
          ExecStart = "${cfg.package}/bin/cloudflared --config ${configFile}";
          Restart = "on-failure";
          RestartSec = "5s";
        };
      };
    }
  );
}
