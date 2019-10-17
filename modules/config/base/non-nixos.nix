{ config, lib, pkgs, ... } @ args:

with lib;

let
  cfg = config.custom.base.non-nixos;

  substituters = [
    "https://cache.nixos.org"
    "https://gerschtli.cachix.org"
    "https://nix-on-droid.cachix.org"
  ];
  trustedPublicKeys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "gerschtli.cachix.org-1:dWJ/WiIA3W2tTornS/2agax+OI0yQF8ZA2SFjU56vZ0="
    "nix-on-droid.cachix.org-1:56snoMJTXmDRC1Ei24CmKoUqvHJ9XCp+nidK7qkMQrU="
  ];
in

{

  ###### interface

  options = {

    custom.base.non-nixos.enable = mkEnableOption "config for non NixOS systems" // {
      default = !config.lib.os.isNixOS;
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    custom.misc = {
      dotfiles = {
        enable = true;
        modules = [ "home-manager" ];
      };

      nix-channels = {
        enable = true;
        nixpkgs = true;
      };
    };

    home.packages = [ pkgs.nix ];

    programs.zsh.envExtra = mkAfter ''
      hash -f
    '';

    xdg.configFile."nix/nix.conf".text = ''
      substituters = ${concatStringsSep " " substituters}
      trusted-public-keys = ${concatStringsSep " " trustedPublicKeys}
    '';

  };

}