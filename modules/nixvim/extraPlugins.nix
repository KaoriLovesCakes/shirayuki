{
  lib,
  pkgs,
  ...
}: {
  extraPlugins = lib.flatten [
    (
      (pkgs.vimUtils.buildVimPlugin {
        name = "floaterm";
        src = pkgs.fetchFromGitHub {
          owner = "nvzone";
          repo = "floaterm";
          rev = "HEAD";
          hash = "sha256-U5AFkHUmDlcjb2WlgdM7d2t9xpeyh9CS9EonAlxwHDw=";
        };
      }).overrideAttrs {
        dependencies = [pkgs.vimPlugins.nvzone-volt];
      }
    )
    (pkgs.vimUtils.buildVimPlugin {
      name = "lorem";
      src = pkgs.fetchFromGitHub {
        owner = "derektata";
        repo = "lorem.nvim";
        rev = "HEAD";
        hash = "sha256-1tTFCR5mNE29nEqi3u7GcsXprkwKgGuilrSl94I6WY0=";
      };
    })
    (
      (pkgs.vimUtils.buildVimPlugin {
        name = "venv-selector";
        src = pkgs.fetchFromGitHub {
          owner = "linux-cultist";
          repo = "venv-selector.nvim";
          rev = "HEAD";
          hash = "sha256-+0bpYcb+sHzcxHxBLzNzeSFqk+hfkPhfmp0yxjuhbg4=";
        };
      }).overrideAttrs {
        dependencies = [pkgs.vimPlugins.telescope-nvim];
      }
    )
    pkgs.vimPlugins.substitute-nvim
  ];
}
