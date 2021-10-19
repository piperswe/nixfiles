{ ... }:
{ pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    initExtra = ''
      ${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin
      ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd history completion)
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    '';
    oh-my-zsh = {
      enable = true;
      theme = "ys";
      plugins = [
        "ag"
        "command-not-found"
        "git"
        "kubectl"
      ] ++ (lib.optionals pkgs.stdenv.isDarwin [ "iterm2" ]);
    };
  };
}
