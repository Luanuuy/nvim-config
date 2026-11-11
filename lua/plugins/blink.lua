require("blink.cmp").setup({
    keymap = { preset = "super-tab" },

    -- 补全来源：LSP、当前 Buffer、文件路径
    sources = {
        default = { "lsp", "path", "snippets", "buffer" },
    },

    -- 模糊匹配引擎
    fuzzy = { implementation = "lua" },

    completion = {
        -- 关闭 Snippet 内自动触发补全
        trigger = { show_in_snippet = false },

        -- 幽灵文本
        ghost_text = { enabled = true },
    },

    -- 函数签名帮助
    signature = { enabled = true },
})
