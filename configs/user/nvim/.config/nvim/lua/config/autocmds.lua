-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Linux kernel style indentation for C/C++
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    vim.opt_local.tabstop = 8
    vim.opt_local.shiftwidth = 8
    vim.opt_local.softtabstop = 8
    vim.opt_local.expandtab = false -- real tabs
    vim.opt_local.textwidth = 80
    vim.opt_local.colorcolumn = "81"
    vim.opt_local.cinoptions = ":0,l1,t0,(0" -- case labels not indented, etc.
  end,
})
