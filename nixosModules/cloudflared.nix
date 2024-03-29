{ ... }:
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.cloudflared;
  settingsFormat = pkgs.formats.yaml { };
in
{
  # I'm not in the maintainers list... yet!
  # meta.maintainers = with maintainers; [ pmc ];

  options = {
    services.cloudflared = {
      enable = mkEnableOption "cloudflared";
      package = mkOption {
        type = types.package;
        default = pkgs.cloudflared;
        description = "The cloudflared package to use";
        example = literalExpression ''pkgs.cloudflared'';
      };
      config = mkOption {
        type = settingsFormat.type;
        description = "Contents of the config.yaml as an attrset; see https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/configuration/configuration-file for documentation on the contents";
        example = literalExpression ''
          {
            url = "http://localhost:3000";
            tunnel = "505c8dd1-e4fb-4ea4-b909-26b8f61ceaaf";
            credentials-file = "/var/lib/cloudflared/505c8dd1-e4fb-4ea4-b909-26b8f61ceaaf.json";
          }
        '';
      };

      configFile = mkOption {
        type = types.path;
        description = "Path to cloudflared config.yaml.";
        example = literalExpression ''"/etc/cloudflared/config.yaml"'';
      };
    };
  };

  config = mkIf cfg.enable ({
    # Prefer the config file over settings if both are set.
    services.cloudflared.configFile = mkDefault (settingsFormat.generate "cloudflared.yaml" cfg.config);

    systemd.services.cloudflared = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "Cloudflare Argo Tunnel";
      serviceConfig = {
        TimeoutStartSec = 0;
        Type = "notify";
        ExecStart = "${cfg.package}/bin/cloudflared --config ${cfg.configFile} --no-autoupdate tunnel run";
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };
  });
}
