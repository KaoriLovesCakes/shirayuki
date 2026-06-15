# 白雪

My [NixOS](https://nixos.org/) and [NixVim](https://nix-community.github.io/nixvim/) config.

> [!NOTE]
> Rolling release.
> Commits are unannounced and undocumented.

## Usage

Export `NIXPKGS_ALLOW_UNFREE=1` and pass flag `--impure` if needed.

### Install NixOS

```fish
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount --flake github:KaoriLovesCakes/shirayuki#shirayuki
sudo nixos-install --flake github:KaoriLovesCakes/shirayuki#shirayuki
```

### Create LiveCD for Installation

```fish
nix --experimental-features "nix-command flakes" build github:KaoriLovesCakes/shirayuki#nixosConfigurations.shirayuki-live.config.system.build.isoImage
```

### Run NixVim

```fish
nix --experimental-features "nix-command flakes" run github:KaoriLovesCakes/shirayuki#neovim
```
