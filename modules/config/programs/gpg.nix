{ config, lib, pkgs, ... } @ args:

with lib;

let
  cfg = config.custom.programs.gpg;
in

{

  ###### interface

  options = {

    custom.programs.gpg = {
      enable = mkEnableOption "gpg config";

      curses = mkEnableOption "pinentry curses";
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    custom = {
      misc.dotfiles = {
        enable = true;
        modules = [ "gpg" ];
      };

      programs.shell.loginExtra = ''
        # remove existing keys
        if [[ $SHLVL -eq 1 ]]; then
          systemctl --user reload gpg-agent.service
        fi
      '';
    };

    programs.gpg.enable = true;

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 300;

      # FIXME: use curses if it not longer requires building gtk2
      pinentryFlavor = mkIf cfg.curses null;
      # pinentryFlavor = mkIf cfg.curses "curses";
      # extraConfig = ''
      #   pinentry-program ${pkgs.pinentry.curses}/bin/pinentry
      # '';
    };

  };

}