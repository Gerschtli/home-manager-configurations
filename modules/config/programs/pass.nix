{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.custom.programs.pass;
in

{

  ###### interface

  options = {

    custom.programs.pass = {
      enable = mkEnableOption "pass config";

      browserpass = mkEnableOption "browserpass";
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    custom.programs.gpg.enable = true;

    programs = {
      browserpass = {
        enable = cfg.browserpass;
        browsers = [ "chrome" ];
      };

      password-store = {
        enable = true;
        package = pkgs.nur-gerschtli.pass;
        settings.PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.password-store";
      };
    };

  };

}
