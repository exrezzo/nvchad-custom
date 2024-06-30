local plugins = {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "gopls",
        "omnisharp_mono",
      },
    },
  },
  {
    "christoomey/vim-tmux-navigator",
    event = "VeryLazy",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    config = function()
      vim.keymap.set('n', '<C-Left>', '<cmd>TmuxNavigateLeft<CR>')
      vim.keymap.set('n', '<C-Down>', '<cmd>TmuxNavigateDown<CR>')
      vim.keymap.set('n', '<C-Up>', '<cmd>TmuxNavigateUp<CR>')
      vim.keymap.set('n', '<C-Right>', '<cmd>TmuxNavigateRight<CR>')
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")

      -- REQUIRED
      harpoon:setup()
      -- REQUIRED

      vim.keymap.set("n", "<leader>hm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
        { desc = "harpoon quick menu" })
      vim.keymap.set("n", "<leader>ha", function() require("harpoon"):list():add() end, { desc = "harpoon file" })
      vim.keymap.set("n", "<leader>1", function() require("harpoon"):list():select(1) end, { desc = "harpoon select 1" })
      vim.keymap.set("n", "<leader>2", function() require("harpoon"):list():select(2) end, { desc = "harpoon select 2" })
      vim.keymap.set("n", "<leader>3", function() require("harpoon"):list():select(3) end, { desc = "harpoon select 3" })
      vim.keymap.set("n", "<leader>4", function() require("harpoon"):list():select(4) end, { desc = "harpoon select 4" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
    opts = {
      capabilities = {
        workspace = {
          didChangeWatchedFiles = {
            dynamicRegistration = true,
          },
        },
      },
    },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    ft = "go",
    opts = function()
      return require "custom.configs.null-ls"
    end,
  },
  {
    "github/copilot.vim",
    event = "BufEnter",
  },
  -- Configurazione per il debug con DAP e la UI
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = {
          "nvim-neotest/nvim-nio",
        },
        config = function()
          local dapui = require("dapui")
          dapui.setup()

          local dap = require("dap")

          dap.listeners.before.attach.dapui_config = function()
            dapui.open()
          end
          dap.listeners.before.launch.dapui_config = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
          end
          dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
          end

          -- questi keymaps li setto qui perche' altrimenti non funzionano
          -- se li metto in mappings.lua
          vim.keymap.set("n", "<F1>", dap.continue, { desc = "debug continue" })
          vim.keymap.set("n", "<F2>", dap.step_into, { desc = "debug step_into" })
          vim.keymap.set("n", "<F3>", dap.step_over, { desc = "debug step_over" })
          vim.keymap.set("n", "<F4>", dap.step_out, { desc = "debug step_out" })
          vim.keymap.set("n", "<F5>", dap.step_back, { desc = "debug step_back" })
          vim.keymap.set("n", "<F7>", dap.terminate, { desc = "debug terminate" })
          vim.keymap.set("n", "<F12>", dap.restart, { desc = "debug restart" })
          vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "debug set_breakpoint" })
          vim.keymap.set("n", "<F10>", dapui.toggle, { desc = "toggle dapui view" })
        end,
      },
    },
    init = function()
      require("core.utils").load_mappings("dap")
    end,
  },
  -- Configurazione per il debug di Go
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function(_, opts)
      require("dap-go").setup(opts)
      -- require("core.utils").load_mappings("dap_go")

      vim.keymap.set("n", "<leader>dct", require("dap-go").debug_test, { desc = "Debug test under cursor" })
    end,
  },
  {
    -- Ho aggiunto questo piccolo plugin che permette di colorare una window che ha 
    -- una codifica in ANSI colors che non riesce a rendirezzare.
    -- Mi può servire ad esempio nella finestra di output di dap-ui che non riesce a mostrare
    -- i colori dei test Go scritti con cucumber
    "m00qek/baleia.nvim",
    version = "*",
    config = function()
      vim.g.baleia = require("baleia").setup({})

      -- Command to colorize the current buffer
      vim.api.nvim_create_user_command("BaleiaColorize", function()
        vim.g.baleia.once(vim.api.nvim_get_current_buf())
      end, { bang = true })

      -- Command to show logs
      vim.api.nvim_create_user_command("BaleiaLogs", vim.g.baleia.logger.show, { bang = true })
    end,
  },

  -- per il testing:
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- "nvim-neotest/neotest-go",
      "fredrikaverpil/neotest-golang",
    },
    config = function()
      -- Commentato momentaneamente perche' non funziona.
      -- Proviamo un attimo neotest-golang.


      -- -- get neotest namespace (api call creates or returns namespace)
      -- local neotest_ns = vim.api.nvim_create_namespace("neotest")
      -- vim.diagnostic.config({
      --   virtual_text = {
      --     format = function(diagnostic)
      --       local message =
      --           diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
      --       return message
      --     end,
      --   },
      -- }, neotest_ns)
      -- require("neotest").setup({
      --   -- your neotest config here
      --   adapters = {
      --     require("neotest-go"),
      --   },
      -- })

      require("neotest").setup({
        adapters = {
          require("neotest-golang"), -- Registration
        },
      })
    end,
  },
  -- {
  --   "vim-test/vim-test",
  --   cmd = {
  --     "TestNearest",
  --     "TestFile",
  --     "TestSuite",
  --     "TestLast",
  --     "TestVisit",
  --   },
  --   config = function()
  --     vim.keymap.set('n', '<leader>o', ':TestNearest<CR>')
  --     -- nmap <silent> <leader>T :TestFile<CR>
  --     -- nmap <silent> <leader>a :TestSuite<CR>
  --     -- nmap <silent> <leader>l :TestLast<CR>
  --     -- nmap <silent> <leader>g :TestVisit<CR>
  --   end
  -- },
  {
    "vim-test/vim-test",
    dependencies = {
      "preservim/vimux"
    },
    event = "VeryLazy",
    config = function()
      vim.keymap.set("n", "<leader>t", ":TestNearest<CR>", {})
      vim.keymap.set("n", "<leader>T", ":TestFile<CR>", {})
      vim.keymap.set("n", "<leader>a", ":TestSuite<CR>", {})
      vim.keymap.set("n", "<leader>l", ":TestLast<CR>", {})
      vim.keymap.set("n", "<leader>g", ":TestVisit<CR>", {})
      vim.cmd("let test#strategy = 'vimux'")
    end,
  }
}
return plugins
