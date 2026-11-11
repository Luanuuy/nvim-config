require("catppuccin").setup({
    -- 主题风格：mocha、macchiato、frappe、latte
    flavour = "mocha",

    -- 主窗口透明背景
    transparent_background = true,

    -- 浮动窗口效果
    float = {
        transparent = true,
        solid = false,
    },

    -- 终端 ANSI 颜色
    term_colors = true,

    -- 自动识别其他支持的插件
    auto_integrations = true,

    integrations = {
        -- Markdown 预览
        markview = true,

        -- 常用 Neovim 功能
        treesitter = true,
        native_lsp = { enabled = true },
    },
})

-- 应用 Catppuccin 主题
vim.cmd.colorscheme("catppuccin-nvim")
