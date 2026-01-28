return {
  -- LSP Package management
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
  -- LSP
  {
    'neovim/nvim-lspconfig'
  }
}
