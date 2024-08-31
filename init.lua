-- creating a Lazy.vim package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.number = true
-- vim.opt.relativenumber = true
vim.opt.mouse = "a"

require("lazy").setup({
  spec = {
  -- telescope installation for file find support
  {'nvim-telescope/telescope.nvim', tag = '0.1.5', dependencies = { 'nvim-lua/plenary.nvim' }},
  -- Tree sitter , syntax highlighter
  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate",
    config = function () 
      local configs = require("nvim-treesitter.configs")
      configs.setup({
          ensure_installed = { "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" , "javascript" ,"typescript" ,"go" ,"rust" ,"python" , "java"},
          sync_install = false,
          highlight = { enable = true },
          indent = { enable = true },  
        })
    end
 },
  -- color scheme
 {"killitar/obscure.nvim",lazy = false,priority = 1000,opts = {}},
  -- Indent support
 {"lukas-reineke/indent-blankline.nvim",main = "ibl",opts = {}},
  -- comment support
 { "danymat/neogen", config = true},
  -- status line
 {'ecthelionvi/NeoColumn.nvim', opts = {always_on = true}},
 {"nvim-tree/nvim-tree.lua", version = "*", lazy = false, dependencies = { "nvim-tree/nvim-web-devicons"},
  config = function()
    require("nvim-tree").setup {}
  end,
 }
},
checker = { enabled = true },
})

-- Color schema
vim.cmd[[colorscheme obscure]]

-- Telescope keybindings
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- File explorer keybindings
local explorer = require "nvim-tree.api"
vim.keymap.set('n', '<leader>xo',explorer.tree.toggle,{})
vim.keymap.set('n', '<leader>xf',explorer.tree.focus,{})
