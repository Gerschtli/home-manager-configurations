{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.custom.wm.dwm;
in

{

  ###### interface

  options = {

    custom.wm.dwm.enable = mkEnableOption "config for dwm";

  };


  ###### implementation

  config = mkIf cfg.enable {

    custom = {
      services = {
        dunst.enable = true;

        dwm-status = {
          inherit (config.custom.base.desktop) laptop;

          enable = true;
        };
      };

      wm.general.enable = true;
    };

    home = {
      keyboard = {
        layout = "de";
        options = [ "ctrl:nocaps" ];
        variant = "nodeadkeys";
      };

      packages = with pkgs; [
        nur-gerschtli.dmenu
        nur-gerschtli.dwm
        playerctl
        scrot
        xclip
        xorg.xkill
      ];

      # Fix java applications
      sessionVariables.AWT_TOOLKIT = "MToolkit";
    };

    services.screen-locker = {
      enable = true;
      lockCmd = "${config.custom.wm.general.lockScreenPackage}/bin/lock-screen";
      inactiveInterval = 60;

      # disable xautolock when cursor is in bottom right corner
      xautolockExtraOptions = [ "-corners" "000-" ];

      # lock before suspending/hibernating, see https://github.com/i3/i3lock/issues/207
      xssLockExtraOptions = [ "--transfer-sleep-lock" ];
    };

    xsession = {
      enable = true;
      windowManager.command = "${pkgs.nur-gerschtli.dwm}/bin/dwm";

      numlock.enable = true;

      initExtra = ''
        # Disable screen saver
        ${pkgs.xorg.xset}/bin/xset s off
        # Disable screen power saving settings
        ${pkgs.xorg.xset}/bin/xset -dpms
        # Increase key repeat speed
        ${pkgs.xorg.xset}/bin/xset r rate 250 30

        # Send notification if last nix-channel --update is more than a week ago
        if [[ $(find /nix/var/nix/profiles/per-user -type l -iname "channels-*" -mtime -7 | wc -l) == 0 ]]; then
            ${pkgs.libnotify}/bin/notify-send "Please update me!" \
              "Last time you updated your nix-channel is more than a week ago.. :("
        fi

        # Fix java applications, dwm needs to be up and running before executing this command
        for i in 1 2 3; do
          sleep 1
          ${pkgs.wmname}/bin/wmname LG3D
        done &
      '';
    };

  };

}
