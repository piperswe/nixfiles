{ vscode-server, ... }:
{ ... }:
{
  imports = [ "${vscode-server}/modules/vscode-server/home.nix" ];
  services.vscode-server.enable = true;
}
