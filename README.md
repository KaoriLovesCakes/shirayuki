# 白雪

Because I'm a princess.

My [NixOS](https://nixos.org/) and [NixVim](https://nix-community.github.io/nixvim/) config.
Might add documentation later.

Wallpaper is from [here](https://box.apeiros.xyz/public/everforest_walls/nature/forest_stairs.jpg).

## Installing NixOS

```fish
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount --flake github:KaoriLovesCakes/shirayuki#shirayuki
sudo nixos-install --flake github:KaoriLovesCakes/shirayuki#shirayuki
```

## Running NixVim

```fish
nix --experimental-features "nix-command flakes" run github:KaoriLovesCakes/shirayuki#neovim
```
