{ ... }:
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.fake-hwclock;
in
{
  # I'm not in the maintainers list... yet!
  # meta.maintainers = with maintainers; [ pmc ];

  options = {
    services.fake-hwclock = {
      enable = mkEnableOption "fake-hwclock";
      package = mkOption {
        type = types.package;
        default = pkgs.fake-hwclock;
        description = "The fake-hwclock package to use";
        example = literalExpression ''pkgs.fake-hwclock'';
      };
    };
  };

  config = mkIf cfg.enable ({
    systemd.services.fake-hwclock = {
      wantedBy = [ "sysinit.target" ];
      before = [ "sysinit.target" "shutdown.target" ];
      conflicts = [ "shutdown.target" ];
      documentation = "man:fake-hwclock(8)";
      description = "Restore / save the current clock";
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/fake-hwclock load";
        ExecStop = "${cfg.package}/bin/fake-hwclock save";
        Type = "oneshot";
        RemainAfterExit = "yes";
      };
    };
  });
}
