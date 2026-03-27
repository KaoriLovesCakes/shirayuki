{
  lib,
  pkgs,
  ...
}:
{
  extraPlugins = lib.flatten [
    (
      (pkgs.vimUtils.buildVimPlugin {
        name = "floaterm";
        src = pkgs.fetchFromGitHub {
          owner = "nvzone";
          repo = "floaterm";
          rev = "HEAD";
          hash = "sha256-kTjE44pp02ZEJUp42p459l4WQA8oQ9SU8AuCxXFYm/k=";
        };
      }).overrideAttrs
      {
        dependencies = [ pkgs.vimPlugins.nvzone-volt ];
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
  ];
}
