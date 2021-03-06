{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.custom.services.dwm-status;
in

{

  ###### interface

  options = {

    custom.services.dwm-status = {
      enable = mkEnableOption "dwm-status user service";

      audio = mkEnableOption "audio feature" // { default = true; };

      laptop = mkEnableOption "laptop config";

      useGlobalAlsaUtils = mkEnableOption "use global alsa utils instead of nix' one";
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    services.dwm-status = {
      enable = true;

      package =
        if cfg.useGlobalAlsaUtils
        then pkgs.nur-gerschtli.dwm-status-without-alsa-utils
        else pkgs.nur-gerschtli.dwm-status;

      order =
        let
          list =
            if cfg.laptop
            then [ "cpu_load" "backlight" "audio" "battery" "time" ]
            else [ "cpu_load" "audio" "time" ];
        in
          if cfg.audio
          then list
          else lists.remove "audio" list;

      extraConfig = mkMerge [
        {
          separator = "    ";
        }

        (mkIf cfg.audio {
          audio = {
            mute = "ﱝ";
            template = "{ICO} {VOL}%";
            icons = [ "奄" "奔" "墳" ];
          };
        })

        (mkIf cfg.laptop {
          backlight = {
            template = "{ICO} {BL}%";
            icons = [ "" "" "" ];
          };

          battery = {
            charging = "";
            discharging = "";
            no_battery = "";
            icons = [ "" "" "" "" "" "" "" "" "" "" "" ];
          };
        })
      ];
    };

  };

}
