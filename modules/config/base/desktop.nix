{ config, lib, pkgs, ... } @ args:
with lib;

let
  cfg = config.custom.base.desktop;
in

{

  ###### interface

  options = {

    custom.base.desktop = {

      enable = mkEnableOption "desktop setup";

      laptop = mkEnableOption "laptop config";

      private = mkEnableOption "private desktop config";

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    custom = {
      development.lorri.enable = true;

      misc.dotfiles = {
        enable = true;
        modules = [ "atom" ];
      };

      programs = {
        pass = mkIf cfg.private {
          enable = true;
          desktop = true;
        };

        ssh.modules = [ "private" ];

        urxvt.enable = true;
      };

      services = {
        dunst.enable = true;

        dwm-status = {
          inherit (cfg) laptop;

          enable = true;
        };
      };

      xsession.enable = true;
    };

    home.packages = with pkgs; [
      gimp
      jetbrains.idea-ultimate
      libreoffice
      pdftk
      postman
      spotify
    ] ++ (optionals cfg.private [
      audacity
      musescore
      thunderbird
    ]) ++ (optionals (cfg.private && cfg.laptop) [
      skypeforlinux
      zoom-us
    ]);

    services = {
      network-manager-applet.enable = cfg.laptop;

      unclutter = {
        enable = true;
        timeout = 3;
      };
    };

  };

}
