# !DEPRECATED! See [nix-config](https://github.com/Gerschtli/nix-config)

I am transitioning to a flakes-only setup within a mono-repo containing all configs.

# Home Manager configurations

This repository manages all my [home manager](https://github.com/rycee/home-manager) configuration files and the
corresponding library of custom modules.

Provides `home.nix` files for each host and user in `home-files` with the structure `home-files/<host>/<user>.nix`:

* `gamer`: wsl2 (ubuntu)
* `localhost`: android phone (based on [nix-on-droid](https://github.com/t184256/nix-on-droid))
* `krypton`: server
* `M386`: work laptop (ubuntu)
* `neon`: personal laptop
* `xenon`: raspberry pi

## Nix Channels

Run `bin/setup-nix-channels`:

```bash
./bin/setup-nix-channels [--android|--non-nixos|--small]
```
