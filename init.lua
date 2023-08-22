-- Author: Eduardo Enrique Niño Martínez 

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.wrap = true
vim.opt.linebreak = true

vim.o.hlsearch = false
vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus'
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.completeopt = 'menuone,noselect'
vim.o.termguicolors = true

vim.wo.signcolumn = 'yes'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  'nvim-lua/plenary.nvim', -- Required for Harpoon, and Telescope
  'folke/neodev.nvim', -- Automatically configures lua-language-server for your Neovim config
  'tpope/vim-sleuth', -- Automatically set the shiftwidth and expandtab settings based on the current file
  'stevearc/oil.nvim', -- File manager
  'nvim-treesitter/nvim-treesitter-textobjects', -- Text objects for treesitter
  'j-morano/buffer_manager.nvim', -- Buffer manager
  'yorickpeterse/nvim-window', -- Jump to windows
  'ggandor/leap.nvim', -- Leap motion to move around quickly, like easymotion
  'famiu/bufdelete.nvim', -- Delete buffers without losing the window layout
  'terrortylor/nvim-comment', -- Commenting code
  'williamboman/mason-lspconfig.nvim', -- LSP Config for Mason
  'j-hui/fidget.nvim', -- Use to see lsp diagnostics
  'neovim/nvim-lspconfig', -- LSP Config for many languages
  'L3MON4D3/LuaSnip', -- Snippets
  'rafamadriz/friendly-snippets', -- Snippets
  'saadparwaiz1/cmp_luasnip', -- Snippets for cmp
  'hrsh7th/cmp-nvim-lsp', -- LSP for cmp
  'hrsh7th/nvim-cmp', -- Autocompletion
  'kdheepak/lazygit.nvim', -- Lazygit

  { 'williamboman/mason.nvim', config = true },

  { 'github/copilot.vim', lazy = false },

  { 'nvim-telescope/telescope.nvim', branch = '0.1.x' },

  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    requires = { {'nvim-lua/plenary.nvim'} },
  },

  {
    'rafamadriz/neon',
    config = function ()
      vim.g.neon_style = 'default'
      vim.g.neon_italic_keyword = true
      vim.g.neon_italic_function = true
      vim.g.neon_transparent = false
    end,
    lazy = false
  },

  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '|' },
        change = { text = '|' },
        delete = { text = '|' },
        topdelete = { text = '|' },
        changedelete = { text = '|' },
      },
      current_line_blame = true,
    },
  },

  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    lazy = false
  },

  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

}, {}) -- End of lazy setup

require('catppuccin').setup({
  flavour = 'frappe', -- latte, frappe, macchiato, mocha, neon
  transparent_background = true,
})

require('nvim-window').setup({
  normal_hl = 'BlackOnLightYellow',
  hint_hl = 'Bold',
  border = 'none',
  chars = {
    'a', 'f', 's', 'd',
  },
})

require('oil').setup({
  columns = {
    -- 'icon',
    -- 'permissions',
    -- 'size',
    -- 'mtime',
  },

  view_options = {
    -- Show files and directories that start with '.'
    show_hidden = true,
  },
})


require('fidget').setup({
    notification = {
      window = {
        winblend = 0,
      },
    },
})

local actions = require('telescope.actions')
require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ['<c-u>'] = false,
        ['<c-d>'] = false,
      },
      n = {
        ['<m-q>'] = false,
        ['<s-Q>'] = actions.send_selected_to_qflist + actions.open_qflist,
        ['<tab>'] = actions.toggle_selection + actions.move_selection_next,
        ['<s-tab>'] = actions.toggle_selection + actions.move_selection_previous,
      },
    },
  },
})

pcall(require('telescope').load_extension, 'fzf')

require('nvim-treesitter.configs').setup({
  ensure_installed = { 'css', 'go', 'html', 'http', 'json', 'lua', 'nim','python', 'rust', 'vimdoc', 'vim','zig'},
  highlight = { enable = true },
  indent = { enable = true },
  auto_install = true,
  modules = {},
  sync_install = false,
  ignore_install = {},
})

local cmp = require('cmp')
local luasnip = require('luasnip')
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup({})

require('cmp').setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      -- behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
})

require('nvim_comment').setup({})
require('neodev').setup({})
require('leap').create_default_mappings()

local harpoon = require('harpoon')
harpoon:setup({})

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- LSP Stuff

local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local mason_lspconfig = require('mason-lspconfig')

mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers({
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end
})

-- LSP Stuff END

-- Keymaps

-- Normal mode

-- Harpoon keymaps

vim.keymap.set('n', '<leader>hb', require('buffer_manager.ui').toggle_quick_menu,{ desc = 'Buffer Manager' })
vim.keymap.set('n', '<leader>ha', function() harpoon:list():append() end,{ desc = 'Harpoon Add File' })
vim.keymap.set('n', '<leader>hh', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,{ desc = 'Harpoon Menu' })

-- Harpoon keymaps END

-- Miscellanous keymaps

vim.keymap.set('n', '<leader>f', require('nvim-window').pick, {desc='Window Pick'})
vim.keymap.set('n', '<Up>', 'gk', {desc='Move Up'})
vim.keymap.set('n', 'k', 'gk', {desc='Move Up'})
vim.keymap.set('n', '<Down>', 'gj', {desc='Move Down'})
vim.keymap.set('n', 'j', 'gj', {desc='Move Down'})
vim.keymap.set('n','U','<cmd>redo<cr>',{desc='Redo'})
vim.keymap.set('n', 'cc', '<cmd>Bdelete<cr>', {desc='Close Buffer Keeping Split'})
vim.keymap.set('n', 'bc', '<cmd>bdelete<cr>', {desc='Close Buffer'})
vim.keymap.set('n', '<leader><Space>', '<C-f>', {desc='Next page'})
vim.keymap.set('n', '<leader><bs>', '<C-b>', {desc='Previous page'})
vim.keymap.set('n', '<leader>dm', '<cmd>delmarks[a-zA-Z[]<>]<cr>', {desc='Chat GPT'})
vim.keymap.set('n', '<m-down>', '<cmd>resize +2<cr>', {desc='Resize Down'})
vim.keymap.set('n', '<m-up>', '<cmd>resize -2<cr>', {desc='Resize Up'})
vim.keymap.set('n', '<m-right>', '<cmd>vertical resize +2<cr>', {desc='Resize Right'})
vim.keymap.set('n', '<m-left>', '<cmd>vertical resize -2<cr>', {desc='Resize Left'})
vim.keymap.set('n', 'f', '<cmd>Oil<cr>', { desc = 'Open parent directory' })

-- Miscellanous keymaps END

-- Telescope keymaps
local config = { previewer = true , layout_config = { width = 0.7 } }

vim.keymap.set('n', '<leader>tt', '<cmd>Telescope<cr>', {desc='Telescope'})
vim.keymap.set('n', '<leader>/', function() require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown(config)) end, { desc = 'Fuzzily search in current buffer' })
vim.keymap.set('n', '<leader>gf', function() require('telescope.builtin').git_files(require('telescope.themes').get_dropdown( config )) end, { desc = 'Search Git Files' })
vim.keymap.set('n', '<leader>sd', function() require('telescope.builtin').diagnostics(require('telescope.themes').get_dropdown( config )) end, { desc = 'Search Diagnostics' })
vim.keymap.set('n', '<leader>sf', function() require('telescope.builtin').find_files(require('telescope.themes').get_dropdown( config )) end, { desc = 'Search Files' })
vim.keymap.set('n', '<leader>sg', function() require('telescope.builtin').live_grep(require('telescope.themes').get_dropdown( config )) end, { desc = 'Search by Grep' })
vim.keymap.set('n', '<leader>ss', function() require('telescope.builtin').help_tags(require('telescope.themes').get_dropdown( config )) end, { desc = 'Search Help' })
vim.keymap.set('n', '<leader>sw', function() require('telescope.builtin').grep_string(require('telescope.themes').get_dropdown( config )) end, { desc = 'Search Word' })

-- Telescope keymaps END

-- LSP keymaps

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- LSP keymaps END

-- Lazygit keymaps
vim.keymap.set('n', '<leader>gh', '<cmd>LazyGit<cr>', {desc='LazyGit'})
-- Lazygit keymaps END

-- Normal mode END

-- Visual mode

vim.keymap.set('v', '<leader>/', ":'<,'>CommentToggle<cr>", {desc='Comment'})
vim.keymap.set('v', '<tab>', '>gv', {desc='Indent'})
vim.keymap.set('v', '<s-tab>', '<gv', {desc='Unindent'})

-- Visual mode END

-- Keymaps END


-- Init with split windows 
vim.cmd('vsplit')

-- Colorscheme
vim.cmd.colorscheme 'neon'
