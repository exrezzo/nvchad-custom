local M = {}

M.general = {
  -- overwrite per la navigazione:
  n = {
    ["<C-Left>"] = { "<C-w>h", "Window left" },
    ["<C-Right>"] = { "<C-w>l", "Window right" },
    ["<C-Down>"] = { "<C-w>j", "Window down" },
    ["<C-Up>"] = { "<C-w>k", "Window up" },
  },

}

M.telescope = {
  plugin = true,

  n = {
    -- per la programmazione:
    ["<leader>fs"] = { "<cmd> Telescope lsp_document_symbols <CR>", "list symbols in buffer" },
    ["<leader>fe"] = { "<cmd> Telescope grep_string <CR>", "search for string everywhere" }
  },
}

M.dap = {
  plugin = true,
  n = {
    ["<leader>dus"] = {
      function()
        local widgets = require('dap.ui.widgets');
        local sidebar = widgets.sidebar(widgets.scopes);
        sidebar.toggle(); -- or sidebar.open()
      end,
      "Toggle debugging sidebar"
    },
  },
}

M.dap_go = {
  plugin = true,
  n = {
    ["<leader>dct"] = {
      function()
        require("dap-go").debug_test()
      end,
      "Debug test under cursor"
    },
  }
}

return M
