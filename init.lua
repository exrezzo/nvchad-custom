local opt = vim.opt

opt.scrolloff = 20
opt.number = true
opt.relativenumber = true
vim.o.statuscolumn = "%s %l %r "

-- copiato da Kickstart! Per evidenziare quando si yanka
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
