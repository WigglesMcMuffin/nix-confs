return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 1200
    end,
    opts = {

    },
    config = function()
      local wk = require("which-key")

      wk.add({
        { "<leader>h", group = "Harpoon" },
        { "<leader>w", group = "Worktree" },
        { "<leader>t", group = "Telescope Finders" },
      })
    end
  }
}
