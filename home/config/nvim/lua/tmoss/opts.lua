vim.opt.fileencodings  = { "utf-8", "default", "latin1" }
vim.opt.helplang       = { "en" }
vim.opt.nrformats      = { "bin", "hex", "unsigned" }

vim.opt.foldmethod     = "expr"
vim.opt.foldexpr       = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevelstart = 99

-- Some plugins update the screen (git diff, etc)
-- They need the page to be auto renewed periodically
vim.opt.updatetime     = 500

vim.opt.display        = "truncate" -- Controls whether the beginning or end of a VERY long line is showed
vim.opt.incsearch      = true -- Show matches as they're being typed
vim.opt.scrolloff      = 8    -- How many lines should the cursor be buffered from the top or bottom
vim.opt.relativenumber = true -- Show the relative line numbers up and down from current line
vim.opt.number         = true -- Show the line number you're currently on
vim.opt.showcmd        = true -- Show the command/chord/selection as it's being built
vim.opt.wildmenu       = true -- Show completions in command mode (basically tab search)
vim.opt.hidden         = true -- Send buffers into memory when unloading, rather that closing
                              -- This is to allow opening a different file, then coming back
                              -- And still having undo/redo history, etc

-- Spacing
vim.opt.tabstop     = 4
vim.opt.softtabstop = 0
vim.opt.expandtab   = true
vim.opt.shiftwidth  = 2
vim.opt.smarttab    = true

vim.opt.termguicolors = true
