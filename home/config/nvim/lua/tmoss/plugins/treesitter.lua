return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = { "lua", "python", "vim", "vimdoc", "javascript", "html", "go", "hcl", "terraform" },
        sync_install = false,
        highlight = {
          enable = true,
          disable = { "html" }
        },
        indent = {
          enable = true,
          disable = { "html" }
        },
      })
    end
  },
}
