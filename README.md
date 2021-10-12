# nixfiles

These files contain the configuration for many of my computers which run [NixOS](https://nixos.org/), as well as other UNIX-based systems which run [home-manager](https://github.com/nix-community/home-manager). I also put customized Nix derivations, NixOS modules, and home-manager modules here.

## Using a NixOS configuration

To use a NixOS configuration from this repo, rebuild your system with this command:

```sh
nixos-rebuild switch --flake github:piperswe/nixfiles
```

It will automatically use the configuration associated with the machine's hostname.

## Using a home-manager configuration

TODO: figure this out

## Using my packages

Add this repo as an input to your flake, then reference the packages attr.

## Using my NixOS modules

Add this repo as an input to your flake, then reference the nixosModules attr.

## Using my home-manager modules

Add this repo as an input to your flake, then reference the homeModules attr.

## License

My nixfiles are licensed under the same [MIT License](COPYING) as nixpkgs itself.
