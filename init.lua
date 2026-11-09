-- 基础选项
require("config.options")
require("config.diagnostics") -- LSP 诊断
require("config.keymaps") -- 注册 Leader 快捷键

-- 插件注册
require("config.plugins")
require("plugins.treesitter")
require("plugins.lsp")

-- 主题
require("plugins.catppuccin") -- Catppuccin

-- 界面与交互
require("plugins.snacks") -- 加载 Snacks 模块化工具集合
require("plugins.which-key") -- 快捷键提示

-- 编辑增强
require("plugins.markview") -- Markdown 预览
require("plugins.flash") -- Flash 快速跳转
require("plugins.surround") -- 成对符号编辑
require("plugins.conform") -- Lua 格式化

-- Git
require("plugins.gitsigns") -- Git 变更管理

-- 自动补全
require("plugins.blink") -- blink.cmp 基础自动补全
