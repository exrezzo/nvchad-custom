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
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end
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
      require("core.utils").load_mappings("dap_go")
    end,
  },
}
return plugins
