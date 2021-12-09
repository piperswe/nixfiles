{ homeConfigurations, ... }:
{ writeShellScriptBin }:
writeShellScriptBin "hm-switch" ''
  exec ${homeConfigurations.pmc.activation-script}/activate
''