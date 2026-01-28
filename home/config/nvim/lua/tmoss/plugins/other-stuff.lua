return {
  { -- :Git command
    "tpope/vim-fugitive"
  },
  { -- Really snazzy git blame interface
    "FabijanZulj/blame.nvim",
    lazy = false,
    opts = {},
  },
  {
    "folke/neoconf.nvim",
    opts = {},
  },
  "junegunn/vim-easy-align",
  {
    -- color schemes
    "protesilaos/prot16-vim",
    config = function()
      vim.cmd.colorscheme("noir_dark")
    end
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {},
  },
  "vim-test/vim-test",
  { "mattn/vim-goimports", enabled=true },
  { "fatih/vim-go", enabled=true },
  "AndrewRadev/splitjoin.vim",
  "SirVer/ultisnips",
  "nvim-lua/popup.nvim",
  {
    "nvim-telescope/telescope-fzf-native.nvim", build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"
  },
}
