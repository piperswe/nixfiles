{ homeModules, nixpkgs-master, lib, ... }:
with lib;
{ pkgs, lib, config, ... }:
let
  pkgsMaster = import nixpkgs-master {
    system = pkgs.stdenv.system;
    config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "plexamp" ];
  };
in
{
  imports = [ homeModules.firefox homeModules.alacritty ];
  options = {
    withGUI = lib.mkEnableOption "GUI";
  };
  config = lib.mkIf config.withGUI {
    home.packages = with pkgs;
      let
        x86_64-linux = stdenv.system == "x86_64-linux";
      in
      universal-packages
        [
          { compatible = x86_64-linux; pkg = tdesktop; }
          { compatible = stdenv.isLinux && !stdenv.isAarch32; pkg = vlc; }
          { compatible = x86_64-linux; pkg = _1password-gui; }
          { compatible = x86_64-linux; pkg = pkgsMaster.plexamp; }
          { compatible = x86_64-linux; pkg = steam; }
          { compatible = x86_64-linux; pkg = steam-run; }
          { compatible = x86_64-linux; pkg = yubioath-desktop; }
          { compatible = stdenv.isLinux; pkg = openrgb; }
          { compatible = builtins.elem stdenv.system [ "x86_64-darwin" "x86_64-linux" "i686-linux" "aarch64-linux" "aarch64-darwin" ]; pkg = element-desktop; }
          { compatible = stdenv.isLinux; pkg = virt-manager; }
          { compatible = builtins.elem stdenv.system [ "i686-linux" "x86_64-linux" ]; pkg = jetbrains.idea-ultimate; }
          { compatible = builtins.elem stdenv.system [ "x86_64-darwin" "aarch64-darwin" "aarch64-linux" "i686-linux" "x86_64-linux" ]; pkg = dhall-lsp-server; }
          { compatible = builtins.elem stdenv.system [ "x86_64-darwin" "aarch64-darwin" "aarch64-linux" "i686-linux" "x86_64-linux" ]; pkg = josm; }
        ];
    allowUnfreePackages = [ "1password" "plexamp" "steam" "steam-original" "steam-runtime" "idea-ultimate" ];

    programs.vscode = lib.mkIf (builtins.elem pkgs.stdenv.system [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "armv7l-linux" ]) {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions;
        let
          generic = [
            editorconfig.editorconfig
            (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
              mktplcRef = {
                publisher = "wayou";
                name = "vscode-todo-highlight";
                version = "1.0.4";
                sha256 = "sha256-OdPcQNZv55v2MGkccXD0qmgmGtXnmS6A2VcjY1YuImk=";
              };
            })
          ];
          rust = [
            tamasfe.even-better-toml
            matklad.rust-analyzer
          ];
          js = [
            dbaeumer.vscode-eslint
            esbenp.prettier-vscode
            octref.vetur
          ];
          ruby = [
            (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
              mktplcRef = {
                publisher = "rebornix";
                name = "Ruby";
                version = "0.28.1";
                sha256 = "sha256-HAUdv+2T+neJ5aCGiQ37pCO6x6r57HIUnLm4apg9L50=";
              };
            })
            (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
              mktplcRef = {
                publisher = "wingrunr21";
                name = "vscode-ruby";
                version = "0.28.0";
                sha256 = "sha256-H3f1+c31x+lgCzhgTb0uLg9Bdn3pZyJGPPwfpCYrS70=";
              };
            })
          ];
          go = [
            golang.go
          ];
          haskell = [
            justusadam.language-haskell
            pkgs.vscode-extensions.haskell.haskell
          ];
          purescript = with pkgs.vscode-utils; [
            (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
              mktplcRef = {
                publisher = "nwolverson";
                name = "language-purescript";
                version = "0.2.5";
                sha256 = "sha256-7o8pGMw66izeEz9INmG0+OT0gOysSOr4zUYgpBS++b0=";
              };
            })
            (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
              mktplcRef = {
                publisher = "nwolverson";
                name = "ide-purescript";
                version = "0.25.2";
                sha256 = "sha256-k+Dokvchw49Rez5jB+eYZUsQENw2VrDXVSXrwJ4fUYA=";
              };
            })
          ];
          terraform = [
            hashicorp.terraform
          ];
          java = [
            (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
              mktplcRef = {
                publisher = "wmanth";
                name = "jar-viewer";
                version = "1.1.0";
                sha256 = "sha256-11BgMivgWuOUPItIxTRdpPy3iy3okW08KF0e55Lcch4=";
              };
            })
          ];
          nix = [
            arrterian.nix-env-selector
            jnoortheen.nix-ide
          ];
          protobuf = [
            zxh404.vscode-proto3
          ];
          dhall = [
            pkgs.vscode-extensions.dhall.dhall-lang
            pkgs.vscode-extensions.dhall.vscode-dhall-lsp-server
          ];
          c-cpp = [
            (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
              mktplcRef = {
                publisher = "asabil";
                name = "meson";
                version = "1.3.0";
                sha256 = "sha256-QMp3dEFx6Mu5pgzklylW6b/ugYbtbT/qz8IeeuzPZeA=";
              };
            })
            (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
              mktplcRef = {
                publisher = "ms-vscode";
                name = "cpptools";
                version = "1.7.1";
                sha256 = "sha256-2vgkfpoQCA+1B4r3h2YjBhnxYf2inCojNDFXALh9hkE=";
              };
            })
          ];
          misc-devops = [
            ms-azuretools.vscode-docker
          ];
        in
        generic
        ++ rust
        ++ js
        ++ ruby
        ++ go
        ++ haskell
        ++ purescript
        ++ terraform
        ++ java
        ++ nix
        ++ protobuf
        ++ dhall
        ++ c-cpp
        ++ misc-devops;
    };
  };
}
