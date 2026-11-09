-- Leader 键
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 终端真彩色
vim.opt.termguicolors = true

-- 行号
vim.opt.number = true
vim.opt.relativenumber = false

-- 缩进
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- 搜索
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- 界面
vim.opt.signcolumn = "yes"
vim.opt.cursorline = false
vim.opt.scrolloff = 5

-- 分屏
vim.opt.splitright = true
vim.opt.splitbelow = true

-- 使用 Windows 系统剪贴板
vim.opt.clipboard = "unnamedplus"

-- 与 Prettier 保持一致
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "json", "jsonc", "yaml" },
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
    end,
})
