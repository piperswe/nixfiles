{ ... }:
{ pkgs, config, ... }:
{
  programs.firefox = {
    enable = config.withGUI;
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
          "network.trr.mode" = 5;
          "gfx.webrender.all" = true;
        };
      };
    };
  };
  allowUnfreePackages = [ "onepassword-password-manager" ];
}
