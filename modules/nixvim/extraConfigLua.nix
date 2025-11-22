{
  extraConfigLua = ''
    require("floaterm").setup({
      border = true,
      mappings = {
       sidebar = function(buf)
         vim.keymap.set("n", "t", require("floaterm").toggle, { buffer = buf })
       end,
       term = function(buf)
         vim.keymap.set("n", "t", require("floaterm").toggle, { buffer = buf })
       end,
      }
    })

    require("lorem").opts({})

    require("substitute").setup({})

    require("venv-selector").setup({})
  '';
}
