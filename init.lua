-- 启动优化：Lua 模块字节码缓存（必须在其余 require 之前）
vim.loader.enable()

-- 基础选项
require("config.options")
require("config.diagnostics")
require("config.keymaps")

-- 插件管理
require("config.plugins")

-- 主题和界面
require("plugins.mini-icons")
require("plugins.catppuccin")
require("config.tabline")

-- 控件与交互
require("plugins.snacks")
require("plugins.which-key")

-- 代码诊断
require("plugins.treesitter")
require("plugins.blink")
require("plugins.lsp")

-- 编辑增强
require("plugins.markview")
require("plugins.flash")
require("plugins.surround")
require("plugins.conform")

-- Git
require("plugins.gitsigns")
