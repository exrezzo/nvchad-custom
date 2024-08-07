local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")
local util = require "lspconfig/util"

lspconfig.gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {"gopls"},
  filetypes = {"go", "gomod", "gowork", "gotmpl"},
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        nilness = true,
        unusedparams = true,
      },
    },
  },
}

lspconfig.omnisharp.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {"omnisharp", "--languageserver"},
  filetypes = {"cs"},
  root_dir = util.root_pattern("*.sln"),
}

lspconfig.tsserver.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {"typescript-language-server", "--stdio"},
  filetypes = {"javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx"},
  root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
}
