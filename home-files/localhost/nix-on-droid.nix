{ config, pkgs, ... }:

{
  imports = [ ../../modules ];

  custom = {
    misc.nonNixos.enable = true;

    programs = {
      prompts.liquidprompt.config = {
        LP_ENABLE_LOAD = 0;
      };

      ssh = {
        enableKeychain = false;
        controlMaster = "no";
        modules = [ "private" ];
      };
    };
  };

  home.sessionVariables = {
    LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
  };

  home.packages = with pkgs; [
    nix
    cacert
    coreutils
    bashInteractive

    diffutils
    findutils
    gawk
    gnugrep
    gnused
    hostname
    man
    ncurses
    openssh
  ];
}