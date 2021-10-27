context:
{
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: with epkgs; [
      # Global
      evil
      magit
      paredit

      # Language-specific
      ## Common Lisp
      slime
      ## Nix
      nix-mode
    ];
  };

  home.file.".emacs.d/init.el".source = ./init.el;
}
