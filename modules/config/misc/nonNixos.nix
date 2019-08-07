{ config, lib, pkgs, ... } @ args:

with lib;

let
  cfg = config.custom.misc.nonNixos;
in

{

  ###### interface

  options = {

    custom.misc.nonNixos = {

      enable = mkEnableOption "config for non NixOS systems";

      nixPath = mkOption {
        type = types.str;
        default = "/nix/var/nix/profiles/per-user/${config.home.username}/channels";
        description = "Value for NIX_PATH variable.";
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    custom = {
      misc.dotfiles = {
        enable = true;
        modules = [ "home-manager" ];
      };

      programs.shell.envExtra = mkBefore ''
        source "${pkgs.nix}/etc/profile.d/nix.sh"

        export NIX_PATH="${cfg.nixPath}"
        export NIX_PROFILES="/etc/profiles/per-user/$USER /run/current-system/sw /nix/var/nix/profiles/default $HOME/.nix-profile"
      '';
    };

    programs.zsh.envExtra = mkAfter ''
      hash -f
    '';

  };

}
