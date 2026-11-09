local severity = vim.diagnostic.severity

vim.diagnostic.config({
    -- 在行尾显示诊断信息
    virtual_text = {
        spacing = 2,
        prefix = "●",
        source = "if_many",
    },

    -- 在符号列显示诊断标记
    signs = {
        text = {
            [severity.ERROR] = "E",
            [severity.WARN] = "W",
            [severity.INFO] = "I",
            [severity.HINT] = "H",
        },
    },

    -- 在存在问题的文本下方显示下划线
    underline = true,

    -- 插入模式下不更新诊断，减少输入时的干扰
    update_in_insert = false,

    -- 优先显示严重程度较高的诊断
    severity_sort = true,

    -- 诊断浮动窗口的默认样式
    float = {
        border = "rounded",
        source = "if_many",
    },
})
