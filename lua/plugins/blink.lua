local blink = require("blink.cmp")

blink.setup({
    -- 使用 Neovim 风格的补全快捷键
    keymap = {
        preset = "super-tab",
    },

    -- 补全来源：LSP、当前 Buffer、文件路径
    sources = {
        default = {
            "lsp",
            "buffer",
            "path",
        },
    },

    -- 使用纯 Lua 实现，避免 Windows 二进制依赖
    fuzzy = {
        implementation = "lua",
    },

    completion = {
        -- 关闭 Snippet 内自动触发补全
        trigger = {
            show_in_snippet = false,
        },

        -- 输入时自动显示补全菜单
        menu = {
            auto_show = true,
        },

        -- 文档窗口按需手动显示
        documentation = {
            auto_show = false,
        },
    },
})
