{ config, pkgs, ... }:

{
  imports = [ ../../modules ];

  custom = {
    base.desktop = {
      enable = true;
      laptop = true;
      private = true;
    };

    wm.dwm.enable = true;
  };

  home.packages = with pkgs; [
    skypeforlinux
    zoom-us
  ];

  services.blueman-applet.enable = true;
}
