-- Track down and exterminate all trailing whitespaces
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  command = "%s/\\s\\+$//e",
})

-- Highlight spaces dangling off the end of lines
vim.cmd('hi HiTabs ctermbg=gray')
vim.cmd('match HiTabs /\\t/')
vim.cmd('hi ExtraWhitespace ctermbg=darkgreen guibg=darkgreen')
vim.cmd('match ExtraWhitespace /\\s\\+$\\| \\+\\ze\\t/')

-- In case I swap color schemes, reapply highlight
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function(args)
    vim.cmd('hi HiTabs ctermbg=gray')
    vim.cmd('hi ExtraWhitespace ctermbg=darkgreen guibg=darkgreen')
  end
})

-- Map keps when opening go files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function(args)
    vim.keymap.set('n', '<leader>r', "<Plug>(go-run)", { desc = "Run go module"})
    vim.keymap.set('n', '<leader>t', "<Plug>(go-test)", { desc = "Test go module"})
    vim.keymap.set('n', '<leader>c', "<Plug>(go-coverage-toggle)", { desc = "Show go coverage"})
    vim.keymap.set('n', '<leader>f', "<Plug>(go-alternate)", { desc = "Uhhhh"})
    --vim.keymap.set('n', '<leader>b', ":<C-u>call <SID>build_go_files()<CR>", { desc = ""})
    vim.g.go_fmt_command = "gofmt"
    vim.g.go_auto_type_info = 1
    vim.g.go_auto_sameids = 1
  end
})

--" vim-go keybinds
--function! s:build_go_files()
--  let l:file = expand('%')
--  if l:file =~# '^\f\+_test\.go$'
--    call go#test#Test(0, 1)
--  elseif l:file =~# '^\f\+\.go$'
--    call go#cmd#Build(0)
--  endif
--endfunction
