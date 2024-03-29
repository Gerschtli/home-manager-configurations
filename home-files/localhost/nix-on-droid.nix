{ config, lib, pkgs, ... }:

{
  imports = [ ../../modules ];

  custom = {
    base = {
      general.lightWeight = true;

      non-nixos = {
        enable = true;
        installNix = false;
      };
    };

    development.nix.nix-on-droid.enable = true;

    misc.dotfiles.modules = [ "nix-on-droid" ];

    programs = {
      shell = {
        envExtra = lib.mkOrder 0 ''
          source "/data/data/com.termux.nix/files/home/.nix-profile/etc/profile.d/nix-on-droid-session-init.sh"
        '';

        initExtra = ''
          if [ -z "''${SSH_AUTH_SOCK:-}" ]; then
            eval $(ssh-agent -s)
          fi
        '';
      };

      ssh = {
        enableKeychain = false;
        controlMaster = "no";
        modules = [ "private" ];
      };

      tmux.enable = lib.mkForce false;
    };
  };

  home = {
    packages = with pkgs; [
      diffutils
      findutils
      gawk
      glibc.bin
      gnugrep
      gnused
      hostname
      man
      ncurses
    ];

    sessionVariables =
      let
        profiles = [ "/nix/var/nix/profiles/default" "$HOME/.nix-profile" ];
        dataDirs =
          lib.concatStringsSep ":" (map (profile: "${profile}/share") profiles);
      in
      {
        XDG_DATA_DIRS = "${dataDirs}\${XDG_DATA_DIRS:+:}$XDG_DATA_DIRS";
      };
  };
}
