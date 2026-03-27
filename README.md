# 白雪

Because I'm a princess.

My [NixOS](https://nixos.org/) and [NixVim](https://nix-community.github.io/nixvim/) config.
Might add documentation later.

## Installing NixOS

```fish
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount --flake github:KaoriLovesCakes/shirayuki#shirayuki
sudo nixos-install --flake github:KaoriLovesCakes/shirayuki#shirayuki
```

## Creating LiveCD for Installation

```fish
nix --experimental-features "nix-command flakes" build github:KaoriLovesCakes/shirayuki#shirayuki-live.config.system.build.isoImage
```

## Running NixVim

```fish
nix --experimental-features "nix-command flakes" run github:KaoriLovesCakes/shirayuki#neovim
```
