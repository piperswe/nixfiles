context:
{
  alacritty = import ./alacritty.nix context;
  base = import ./base.nix context;
  emacs = import ./emacs context;
  firefox = import ./firefox.nix context;
  fish = import ./fish.nix context;
  git = import ./git.nix context;
  gui = import ./gui.nix context;
  neovim = import ./neovim.nix context;
  ssh = import ./ssh.nix context;
  vscode-server = import ./vscode-server.nix context;
  zsh = import ./zsh.nix context;
}
