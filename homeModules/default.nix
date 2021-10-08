context:
{
  base = import ./base.nix context;
  firefox = import ./firefox.nix context;
  git = import ./git.nix context;
  gui = import ./gui.nix context;
  neovim = import ./neovim.nix context;
  vscode-server = import ./vscode-server.nix context;
  zsh = import ./zsh.nix context;
}
