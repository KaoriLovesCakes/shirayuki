{lib, ...}: {
  plugins.conform-nvim = {
    enable = true;
    settings = {
      format_on_save = lib.nixvim.mkRaw "{}";
      formatters = {
        clang-format.prepend_args = ["--style=microsoft"];
        # prettier.prepend_args = [
        #   "--config"
        #   (builtins.toFile ".prettierrc.yaml" ''
        #     tabWidth: 4
        #     proseWrap: "always"
        #   '')
        # ];
      };
      formatters_by_ft = {
        "*" = ["trim_whitespace"];
        cpp = ["clang-format"];
        json = ["fixjson"];
        # markdown = ["prettier"];
        markdown = ["markdownlint"];
        nix = ["alejandra"];
        python = [
          "ruff_fix"
          "ruff_format"
          "ruff_organize_imports"
        ];
        rust = ["rustfmt"];
        typst = ["typstyle"];
      };
    };
  };
}
