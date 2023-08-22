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
  'nvim-lua/plenary.nvim',
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'tpope/vim-sleuth',
  'tpope/vim-dadbod',
  'kristijanhusak/vim-dadbod-ui',
  'MunifTanjim/nui.nvim',

  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    requires = { {'nvim-lua/plenary.nvim'} },
  },

  {
    'rafamadriz/neon',
    config = function ()
      vim.cmd.colorscheme 'neon'
      vim.g.neon_style = 'default'
      vim.g.neon_italic_keyword = true
      vim.g.neon_italic_function = true
      vim.g.neon_transparent = true
    end,
    lazy = true
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
    lazy = true,
  },

  {
    'github/copilot.vim',
    lazy = false,
  },

  {
    'stevearc/oil.nvim',
    opts = {},
    dependencies = { 'nvim-tree/nvim-web-devicons' },

    config = function ()
      require('oil').setup({
        columns = {
          -- 'icon',
          -- 'permissions',
          -- 'size',
          -- 'mtime',
        },
        keymaps = {
          ['<leader>p'] = 'actions.preview',
          ['<leader>h'] = 'actions.toggle_hidden',
        }
      })
    end
  },

  {
    'rest-nvim/rest.nvim',
    config = function()
      require('rest-nvim').setup({})
    end
  },

  {
    'kdheepak/lazygit.nvim',
  },

  {
    'terrortylor/nvim-comment',
    config = function ()
      require('nvim_comment').setup()
    end
  },

  {
    'ggandor/lightspeed.nvim'
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim',opts = {} },
      'folke/neodev.nvim',
    },
  },

  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'rafamadriz/friendly-snippets',
    },
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
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk, { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
        vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
        vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
      end,
      current_line_blame = true,
    },
  },

  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup({
        flavour = 'mocha', -- latte, frappe, macchiato, mocha
        transparent_background = true,
      })
      vim.cmd.colorscheme 'catppuccin'
    end,
    lazy = false
  },

  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        icons_enabled = true,
        theme = 'catppuccin', -- catppuccin
        component_separators = '|',
        section_separators = '',
      },
    },
    lazy = false,
  },

  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },

  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  {
    'jackMort/ChatGPT.nvim',
    config = function()
      require('chatgpt').setup({
        api_key_cmd = 'echo -n $OPENAI_API_KEY',
        openai_params = {
          model = 'gpt-3.5-turbo',
          max_tokens = 500,
        },
      })
    end,
    requires = {
      'MunifTanjim/nui.nvim',
      'nvim-telescope/telescope.nvim'
    }
  },

}, {})

local harpoon = require('harpoon')
harpoon:setup({})

local conf = require('telescope.config').values
local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require('telescope.pickers').new({}, {
        prompt_title = 'Harpoon',
        finder = require('telescope.finders').new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

require('fidget').setup {
    notification = {
      window = {
        winblend = 0,
      },
    },
}

local actions = require('telescope.actions')
require('telescope').setup {
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
}

pcall(require('telescope').load_extension, 'fzf')

-- Keymaps

-- Normal mode

-- Harpoon keymaps

vim.keymap.set('n', '<leader>hh', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,{ desc = 'Harpoon Menu' })
vim.keymap.set('n', '<leader>ha', function() harpoon:list():append() end,{ desc = 'Harpoon Add File' })
vim.keymap.set('n', '<leader>sh', function() toggle_telescope(harpoon:list()) end,{ desc = 'Search Harpoon' })

-- Harpoon keymaps END

-- Miscellanous keymaps

vim.keymap.set('n', '<Up>', 'gk', {desc='Move Up'})
vim.keymap.set('n', 'k', 'gk', {desc='Move Up'})
vim.keymap.set('n', '<Down>', 'gj', {desc='Move Down'})
vim.keymap.set('n', 'j', 'gj', {desc='Move Down'})
vim.keymap.set('n','U','<cmd>redo<cr>',{desc='Redo'})
vim.keymap.set('n', 'cc', '<cmd>close<cr>', {desc='Close window'})
vim.keymap.set('n', '<leader>bh', '<cmd>split<cr>', {desc='Split Horizontal'})
vim.keymap.set('n', '<leader>bv', '<cmd>vsplit<cr>', {desc='Split Vertical'})
vim.keymap.set('n', '<leader><Space>', '<C-f>', {desc='Next page'})
vim.keymap.set('n', '<leader><bs>', '<C-b>', {desc='Previous page'})
vim.keymap.set('n', '<leader>ch', '<cmd>ChatGPT<cr>', {desc='Chat GPT'})
vim.keymap.set('n', '<leader>dm', '<cmd>delmarks[a-zA-Z[]<>]<cr>', {desc='Chat GPT'})
vim.keymap.set('n', '<m-down>', '<cmd>resize +2<cr>', {desc='Resize Down'})
vim.keymap.set('n', '<m-up>', '<cmd>resize -2<cr>', {desc='Resize Up'})
vim.keymap.set('n', '<m-right>', '<cmd>vertical resize +2<cr>', {desc='Resize Right'})
vim.keymap.set('n', '<m-left>', '<cmd>vertical resize -2<cr>', {desc='Resize Left'})
vim.keymap.set('n','<leader>gg','<cmd>LazyGit<cr>',{desc='Lazy Git'})
vim.keymap.set('n','<leader>bc','<cmd>bd<cr>',{desc='Close buffer'})
vim.keymap.set('n','<leader>ba','<cmd>bufdo bd<cr>',{desc='Close all buffers'})
vim.keymap.set('n', '<leader>do', '<cmd>DBUIToggle<cr>', {desc='Toggle DB'})
vim.keymap.set('n','<leader>rt','<plug>RestNvim<cr>',{desc='Rest Nvim'})
vim.keymap.set('n', '<leader>nn', '<cmd>lua vim.wo.relativenumber = not vim.wo.relativenumber vim.wo.number = not vim.wo.number<cr>',{desc='Set no number'})
vim.keymap.set('n', 'f', '<cmd>Oil<cr>', { desc = 'Open parent directory' })
vim.keymap.set('n', 'cd', [[<cmd>lua local dir = require('oil').get_current_dir(); vim.cmd('cd ' .. dir)<cr>]],{ desc='Change Directory' })

-- Miscellanous keymaps END

-- Telescope keymaps

vim.keymap.set('n', '<leader>tt', '<cmd>Telescope<cr>', {desc='Telescope'})
vim.keymap.set('n', '<leader>/', require('telescope.builtin').current_buffer_fuzzy_find, { desc = 'Fuzzily search in current buffer' })
vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search Git Files' })
vim.keymap.set('n', '<leader>sb', require('telescope.builtin').buffers, { desc = 'Search Buffers' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = 'Search Diagnostics' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = 'Search Files' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = 'Search by Grep' })
vim.keymap.set('n', '<leader>ss', require('telescope.builtin').help_tags, { desc = 'Search Help' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = 'Search Word' })

-- Telescope keymaps END

-- LSP keymaps

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- LSP keymaps END

-- Normal mode END

-- Visual mode

vim.keymap.set('v', '<leader>/', ":'<,'>CommentToggle<cr>", {desc='Comment'})
vim.keymap.set('v', '<tab>', '>gv', {desc='Indent'})
vim.keymap.set('v', '<s-tab>', '<gv', {desc='Unindent'})

-- Visual mode END

-- Keymaps END

require('nvim-treesitter.configs').setup {
  ensure_installed = { 'css', 'go', 'html', 'http', 'json', 'lua', 'nim','python', 'rust', 'vimdoc', 'vim','zig'},
  highlight = { enable = true },
  indent = { enable = true },
  auto_install = true,
}

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

require('neodev').setup()

local highlight = {
    'RainbowRed',
    'RainbowYellow',
    'RainbowBlue',
    'RainbowOrange',
    'RainbowGreen',
    'RainbowViolet',
    'RainbowCyan',
}

local hooks = require 'ibl.hooks'
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#E06C75' })
    vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#E5C07B' })
    vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61AFEF' })
    vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#D19A66' })
    vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#98C379' })
    vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#C678DD' })
    vim.api.nvim_set_hl(0, 'RainbowCyan', { fg = '#56B6C2' })
end)

require('ibl').setup { indent = { highlight = highlight } }

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end
}

local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
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
}

local script_path = debug.getinfo(1).source:match('@?(.*/)')
package.path = script_path .. '?.lua;' .. package.path

pcall(require, 'dbs')
-- Example dbs.lua config
-- vim.g.dbs = {
--        db_name = 'postgres://user:password@localhost:5432/db_name',
-- }
