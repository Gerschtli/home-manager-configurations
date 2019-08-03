{ config, lib, pkgs, ... } @ args:

with lib;

let
  cfg = config.custom.base.general;

  customLib = import ../../lib args;

  overlays = customLib.getFileList ../../overlays;

  localeGerman = "de_DE.UTF-8";
  localeEnglish = "en_US.UTF-8";

  sessionVariables = {
    LC_CTYPE = localeEnglish;
    LC_NUMERIC = localeEnglish;
    LC_TIME = localeGerman;
    LC_COLLATE = localeEnglish;
    LC_MONETARY = localeEnglish;
    LC_MESSAGES = localeEnglish;
    LC_PAPER = localeGerman;
    LC_NAME = localeEnglish;
    LC_ADDRESS = localeEnglish;
    LC_TELEPHONE = localeEnglish;
    LC_MEASUREMENT = localeGerman;
    LC_IDENTIFICATION = localeEnglish;
    LC_ALL = "";

    LANG = localeEnglish;
    LANGUAGE = localeEnglish;

    TERM = "screen-256color";

    PAGER = "${pkgs.less}/bin/less -FRX";
  };
in

{

  ###### interface

  options = {

    custom.base.general = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable basic config.
        '';
      };

      extendedPath = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Extend PATH with provided list of directories.
        '';
      };
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    custom = {
      programs = {
        bash.enable = true;

        fzf.enable = true;

        git.enable = true;

        htop.enable = true;

        neovim.enable = true;

        prompts.liquidprompt.enable = true;

        shell.envExtra = mkIf (cfg.extendedPath != []) ''
          export PATH="${concatStringsSep ":" cfg.extendedPath}:$PATH"
        '';

        ssh.enable = true;

        tmux.enable = true;

        zsh.enable = true;
      };

      misc.util-bins = {
        enable = true;
        bins = [ "system-update" ];
      };
    };

    home = {
      inherit sessionVariables;

      packages = with pkgs; [
        bc
        file
        httpie
        iotop
        jq
        nox
        pwgen
        ripgrep
        tree
        wget

        gzip
        unzip
        xz
        zip

        bind # dig
        netcat
        psmisc # killall
        whois
      ];

      stateVersion = "19.03";
    };

    nixpkgs = {
      config = import ../../files/config.nix;
      overlays = map (file: import file) overlays;
    };

    programs.home-manager = {
      enable = true;
      path = "$HOME/projects/home-manager";
    };

    xdg.configFile = {
      "nixpkgs/config.nix".source = ../../files/config.nix;
    } // builtins.listToAttrs (
      map (file: {
        name = "nixpkgs/overlays/${baseNameOf file}";
        value.source = file;
      }) overlays
    );

  };

}