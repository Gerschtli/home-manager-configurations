# Home Manager configurations

This repository manages all my [home manager](https://github.com/rycee/home-manager) configuration files and the
corresponding library of custom modules.

Provides `home.nix` files for each host and user in `home-files` with the structure `home-files/<host>/<user>.nix`.

## Nix Channels

Edit your `~/.nix-channels` like the following and run `nix-channel --update`:
```
https://nixos.org/channels/nixos-19.03 nixos
https://nixos.org/channels/nixos-unstable unstable
https://github.com/Gerschtli/home-manager/archive/local.tar.gz home-manager
```
