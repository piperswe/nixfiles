{ ... }:
{ pkgs, lib, config, ... }:
{
  config = lib.mkIf
    (config.withGUI && pkgs.stdenv.isLinux && !pkgs.stdenv.isAarch32 && !pkgs.stdenv.isi686)
    {
      programs.firefox = {
        enable = true;
        package = if pkgs.stdenv.isAarch64 then pkgs.firefox.override { pipewireSupport = false; } else pkgs.firefox;
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          onepassword-password-manager
          metamask
          https-everywhere
          ipfs-companion
          multi-account-containers
          react-devtools
          ublock-origin
          vue-js-devtools
        ];
        profiles = {
          pmc = {
            name = "Piper";
            id = 0;
            settings = {
              "gfx.webrender.all" = true;
            };
          };
        };
      };
      allowUnfreePackages = [ "onepassword-password-manager" ];
    };
}
