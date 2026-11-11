-- Leader 键（必须在插件加载前设置）
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

-- 终端与外观
opt.termguicolors = true -- 开启终端真彩色
opt.number = true -- 开启绝对行号
opt.relativenumber = false -- 关闭相对行号
opt.signcolumn = "yes" -- 始终保留标记列
opt.cursorline = false -- 不突出显示当前行
opt.scrolloff = 5 -- 垂直滚动保留 5 行可见内容
opt.sidescrolloff = 8 -- 水平滚动保留 8 列可见内容
opt.winborder = "rounded" -- 浮窗默认圆角边框
-- ⚠️ 仅在自建状态栏显示模式时才关；0.12 默认状态栏不含模式指示
-- opt.showmode = false

-- 缩进
opt.expandtab = true -- 缩进时优先使用空格
opt.shiftwidth = 4 -- 指定一级缩进宽度为 4
opt.tabstop = 4 -- 真实 tab 显示宽度为 4
opt.softtabstop = 4 -- Tab 或退格以 4 列制表位进行操作
opt.breakindent = true -- 自动换行后保留视觉缩进
opt.shiftround = true -- 缩进调整时对齐 shiftwidth 的倍数

-- 搜索
opt.ignorecase = true -- 搜索时默认忽略大小写
opt.smartcase = true -- 启用智能大小写判断
opt.incsearch = true -- 实时跳转和显示匹配结果
opt.inccommand = "split" -- 实时预览替换命令

-- 编辑体验
vim.opt.foldlevelstart = 99 -- 打开文件时自动展开所有代码
opt.undofile = true -- 持久化撤销历史
opt.updatetime = 300 -- CursorHold 触发和交换文件空闲写入间隔
opt.timeoutlen = 400 --等待超时时间
opt.confirm = true -- 对尚未保存的修改进行确认
opt.mouse = "a" -- 启用鼠标操作
opt.clipboard = "unnamedplus" -- 使用系统剪贴板
opt.splitright = true -- 垂直分割窗口
opt.splitbelow = true -- 水平分割窗口
opt.splitkeep = "screen" -- 水平分割窗口关闭时尽量让原有文本保持在相同屏幕行
opt.virtualedit = "block" -- 在可视块模式中使用虚拟编辑位置
opt.whichwrap = "b,s,<,>,[,]" -- 方向键跨行
opt.list = true -- 显示不可见字符
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.fillchars = { eob = " ", fold = " ", foldopen = "▾", foldclose = "▸" }

-- 持久化撤销目录
local undodir = vim.fn.stdpath("state") .. "/undo"
vim.fn.mkdir(undodir, "p")
opt.undodir = undodir

-- 与 Prettier 保持一致
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("UserIndent", { clear = true }),
    pattern = { "json", "jsonc", "yaml" },
    callback = function()
        vim.opt_local.expandtab = true
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
    end,
})
