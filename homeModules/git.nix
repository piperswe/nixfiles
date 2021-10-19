{ gitignore, ... }:
{ pkgs, lib, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "Piper McCorkle";
    userEmail = lib.mkDefault "contact@piperswe.me";
    ignores =
      let
        files = [
          "${gitignore}/Global/Emacs.gitignore"
          "${gitignore}/Global/Linux.gitignore"
          "${gitignore}/Global/JetBrains.gitignore"
          "${gitignore}/Global/Mercurial.gitignore"
          "${gitignore}/Global/Vim.gitignore"
          "${gitignore}/Global/VisualStudioCode.gitignore"
        ];
        contents = map builtins.readFile files;
        ignoreStr = pkgs.lib.foldr (a: b: a + b) "" contents;
      in
      pkgs.lib.splitString "\n" ignoreStr;
    lfs.enable = true;
    delta.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
