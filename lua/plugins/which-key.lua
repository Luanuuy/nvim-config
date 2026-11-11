local wk = require("which-key")

wk.setup({
    preset = "modern",
    delay = 200,
})

-- =========================================================
-- 快捷键分组
-- =========================================================

wk.add({
    { "<leader>b", group = "Buffer" },
    { "<leader>c", group = "代码/诊断" },
    { "<leader>f", group = "文件/搜索" },
    { "<leader>g", group = "Git" },
    { "<leader>m", group = "Markdown" },
    { "<leader>u", group = "界面/工具" },
    { "<leader>w", group = "窗口管理" },
})
