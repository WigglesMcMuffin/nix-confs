return {
  {
    "polarmutex/git-worktree.nvim",
    version = '^2',
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    keys = {
      { "<leader>ws", function() require("telescope").extensions.git_worktree.git_worktree() end, desc = "List worktrees" },
      { "<leader>wc", function() require("telescope").extensions.git_worktree.create_git_worktree() end, desc = "Create new worktree" },
    },
    config = function()
      require("telescope").load_extension("git_worktree")

      local Hooks = require('git-worktree.hooks')
      Hooks.register(Hooks.type.SWITCH, Hooks.builtins.update_current_buffer_on_switch)
      Hooks.register(Hooks.type.SWITCH, function(path, prev_path)
        vim.notify("switched from " .. prev_path .. " to " .. path .. "... maybe")
      end)
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    -- tag = "0.1.6", backup old conf
    version = "8",
    dependencies = {
      "nvim-lua/plenary.nvim",
       {
         "nvim-telescope/telescope-fzf-native.nvim",
         build = "make",
       },
    },
    keys = {
      { "<leader>tf", "<cmd>Telescope find_files<cr>", desc = "Telescope: Find files in working directory" },
      { "<leader>tg", "<cmd>Telescope live_grep<cr>", desc = "Telescope: Live grep for texts matches in files in working directory" },
      { "<leader>tr", "<cmd>Telescope registers<cr>", desc = "Telescope: Open paste registers Registers picker" },
      { "<leader>tt", "<cmd>Telescope builtin<cr>", desc = "Telescope: Open the Telescope Builtin pickers picker" },
    },
    config = function()
      local telescope = require('telescope')
      telescope.setup({
        pickers = {
          live_grep = {
            file_ignore_patterns = { 'node_modules', '.git', '.venv' },
            additional_args = function(_)
              return { "--hidden" }
            end
          },
          find_files = {
            file_ignore_patterns = { 'node_modules', '.git', '.venv' },
            hidden = true
          },
        },
        extensions = {
          "fzf"
        },
      })
      telescope.load_extension("fzf")
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")

      harpoon:setup({})

      local conf = require('telescope.config').values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require("telescope.pickers").new({}, {
          prompt_title = "Harpoon",
          finder = require("telescope.finders").new_table({
            results = file_paths,
          }),
          previewer = conf.file_previewer({}),
          sorter = conf.generic_sorter({}),
        }):find()
      end

      vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Add mark to harpoon list" })
      vim.keymap.set("n", "<leader>hl", function() toggle_telescope(harpoon:list()) end, { desc = "Open harpoon window" })
    end,
  },
}

