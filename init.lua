-- ============================================================================
-- Neovim Configuration for Java Spring Development
-- ============================================================================

-- Set leader key early
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================================================
-- Basic Settings
-- ============================================================================

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- UI
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.wrap = false
opt.splitbelow = true
opt.splitright = true

-- Backup and undo
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.undodir = vim.fn.expand("~/.vim/undodir")

-- Completion
opt.completeopt = "menu,menuone,noselect"

-- Update time for better responsiveness
opt.updatetime = 300
opt.timeoutlen = 400

-- Enable mouse
opt.mouse = "a"

-- Clipboard
opt.clipboard = "unnamedplus"

-- File encoding
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

-- ============================================================================
-- Bootstrap lazy.nvim Plugin Manager
-- ============================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- Plugin Specifications
-- ============================================================================

require("lazy").setup({
  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 35 },
        filters = { dotfiles = false },
        git = { enable = true },
      })
    end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "node_modules", "target", ".git" },
        },
      })
    end,
  },

  -- Treesitter for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.install").prefer_git = true
      require("nvim-treesitter.install").compilers = { "gcc", "clang" }
      
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        ensure_installed = { "java", "lua", "vim", "yaml", "json", "xml", "sql", "html", "css", "javascript" },
        sync_install = false,
        auto_install = true,
        highlight = { 
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
      })
    end,
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
  },

  -- Java LSP support
  {
    "mfussenegger/nvim-jdtls",
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- Mason for managing LSP servers
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "jdtls", "yamlls", "jsonls", "html", "cssls" },
      })
    end,
  },

  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          section_separators = "",
          component_separators = "|",
        },
      })
    end,
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },

  -- Comments
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup()
    end,
  },

  -- Which-key for keybinding help
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup()
    end,
  },

  -- DAP for debugging
  {
    "mfussenegger/nvim-dap",
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      require("dapui").setup()
    end,
  },

  -- Spring Boot specific
  {
    "JavaHello/spring-boot.nvim",
    dependencies = {
      "mfussenegger/nvim-jdtls",
      "neovim/nvim-lspconfig",
    },
    ft = "java",
  },

  -- Better terminal
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<c-\>]],
        direction = "horizontal",
      })
    end,
  },
})

-- ============================================================================
-- LSP Configuration for non-Java languages
-- ============================================================================

local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- YAML (for Spring application.yml files)
lspconfig.yamlls.setup({
  capabilities = capabilities,
  settings = {
    yaml = {
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "/docker-compose.yml",
      },
    },
  },
})

-- JSON
lspconfig.jsonls.setup({
  capabilities = capabilities,
})

-- HTML
lspconfig.html.setup({
  capabilities = capabilities,
})

-- CSS
lspconfig.cssls.setup({
  capabilities = capabilities,
})

-- ============================================================================
-- JDTLS Configuration (Java Language Server)
-- ============================================================================

local function setup_jdtls()
  local jdtls = require("jdtls")
  
  -- Find the Java installation
  local home = os.getenv("HOME")
  local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
  local workspace_dir = home .. "/.cache/jdtls/workspace/" .. project_name

  -- Ensure workspace directory exists
  vim.fn.mkdir(workspace_dir, "p")

  local config = {
    cmd = {
      "java",
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=ALL",
      "-Xmx1g",
      "--add-modules=ALL-SYSTEM",
      "--add-opens", "java.base/java.util=ALL-UNNAMED",
      "--add-opens", "java.base/java.lang=ALL-UNNAMED",
      "-jar", vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
      "-configuration", jdtls_path .. "/config_linux",
      "-data", workspace_dir,
    },

    root_dir = jdtls.setup.find_root({".git", "mvnw", "gradlew", "pom.xml", "build.gradle"}),

    settings = {
      java = {
        eclipse = {
          downloadSources = true,
        },
        configuration = {
          updateBuildConfiguration = "interactive",
          runtimes = {
            -- Add your Java runtimes here if you have multiple versions
            -- {
            --   name = "JavaSE-17",
            --   path = "/usr/lib/jvm/java-17-openjdk/",
            -- },
          },
        },
        maven = {
          downloadSources = true,
        },
        implementationsCodeLens = {
          enabled = true,
        },
        referencesCodeLens = {
          enabled = true,
        },
        references = {
          includeDecompiledSources = true,
        },
        format = {
          enabled = true,
          settings = {
            url = vim.fn.stdpath("config") .. "/lang-servers/intellij-java-google-style.xml",
            profile = "GoogleStyle",
          },
        },
      },
      signatureHelp = { enabled = true },
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*",
        },
        importOrder = {
          "java",
          "javax",
          "com",
          "org"
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        useBlocks = true,
      },
    },

    init_options = {
      bundles = {},
    },

    capabilities = capabilities,
  }

  -- Keymaps for Java
  local function on_attach(client, bufnr)
    local opts = { buffer = bufnr, silent = true }
    
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, opts)
    
    -- Java specific
    vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, opts)
    vim.keymap.set("n", "<leader>jv", jdtls.extract_variable, opts)
    vim.keymap.set("n", "<leader>jc", jdtls.extract_constant, opts)
    vim.keymap.set("v", "<leader>jm", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], opts)
    vim.keymap.set("n", "<leader>jt", jdtls.test_class, opts)
    vim.keymap.set("n", "<leader>jn", jdtls.test_nearest_method, opts)
  end

  config.on_attach = on_attach

  jdtls.start_or_attach(config)
end

-- Auto-configure JDTLS for Java files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = setup_jdtls,
})

-- ============================================================================
-- Key Mappings
-- ============================================================================

local keymap = vim.keymap.set

-- File explorer
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle file explorer" })

-- Telescope
keymap("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files" })
keymap("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Live grep" })
keymap("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Find buffers" })
keymap("n", "<leader>fh", ":Telescope help_tags<CR>", { desc = "Help tags" })
keymap("n", "<leader>fr", ":Telescope oldfiles<CR>", { desc = "Recent files" })

-- Buffer navigation
keymap("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
keymap("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
keymap("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Window resizing
keymap("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
keymap("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
keymap("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
keymap("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Clear search highlighting
keymap("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear search highlight" })

-- Better indenting in visual mode
keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })

-- Move text up and down
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move text down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move text up" })

-- Keep cursor centered when scrolling
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")

-- Save and quit
keymap("n", "<leader>w", ":w<CR>", { desc = "Save file" })
keymap("n", "<leader>q", ":q<CR>", { desc = "Quit" })
keymap("n", "<leader>x", ":x<CR>", { desc = "Save and quit" })

-- DAP (Debugging)
keymap("n", "<leader>db", ":DapToggleBreakpoint<CR>", { desc = "Toggle breakpoint" })
keymap("n", "<leader>dc", ":DapContinue<CR>", { desc = "Continue debugging" })
keymap("n", "<leader>di", ":DapStepInto<CR>", { desc = "Step into" })
keymap("n", "<leader>do", ":DapStepOver<CR>", { desc = "Step over" })
keymap("n", "<leader>du", ":lua require('dapui').toggle()<CR>", { desc = "Toggle DAP UI" })

-- ============================================================================
-- Auto Commands
-- ============================================================================

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Auto format on save for Java files
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.java",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Close certain filetypes with 'q'
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help", "qf", "lspinfo" },
  callback = function()
    vim.keymap.set("n", "q", ":close<CR>", { buffer = true, silent = true })
  end,
})

-- ============================================================================
-- Spring Boot Specific Settings
-- ============================================================================

-- Recognize Spring Boot application properties/yaml
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "application*.properties", "application*.yml", "application*.yaml" },
  callback = function()
    vim.bo.filetype = "yaml"
  end,
})

-- ============================================================================
-- Final Notes
-- ============================================================================

-- After saving this file, run the following commands in Neovim:
-- :Lazy sync
-- :MasonInstall jdtls yamlls jsonls html cssls
-- 
-- Make sure you have the following installed on your system:
-- - Java JDK (11 or higher)
-- - Maven or Gradle
-- - Node.js (for some LSP servers)
-- - ripgrep (for Telescope live grep)
-- - fd (for better file finding with Telescope)

