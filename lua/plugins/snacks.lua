local Snacks = require("snacks")

Snacks.setup({
    -- 文件、内容及 Buffer 搜索
    picker = {
        enabled = true,
    },

    -- 通知
    notifier = {
        enabled = true,
        timeout = 3000,
    },

    -- 输入弹窗
    input = {
        enabled = true,
    },

    -- 文件浏览器
    explorer = {
        enabled = true,
    },

    -- 启动界面
    dashboard = {
        enabled = true,

        sections = {
            { section = "header" },
            { section = "keys", gap = 1, padding = 1 },
        },
    },

    -- 平滑滚动
    scroll = {
        enabled = true,
    },

    -- 缩进参考线
    indent = {
        enabled = true,
    },

    -- 不使用终端图片渲染
    image = {
        enabled = false,
    },

    -- 暂不使用的其他模块
    bigfile = { enabled = false },
    quickfile = { enabled = false },
    scope = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = false },
})

-- 文件搜索
vim.keymap.set("n", "<leader>ff", function()
    Snacks.picker.files()
end, { desc = "查找文件" })

-- 全文搜索
vim.keymap.set("n", "<leader>fg", function()
    Snacks.picker.grep()
end, { desc = "全文搜索" })

-- Buffer 搜索
vim.keymap.set("n", "<leader>fb", function()
    Snacks.picker.buffers()
end, { desc = "查找 Buffer" })

-- 最近文件
vim.keymap.set("n", "<leader>fr", function()
    Snacks.picker.recent()
end, { desc = "最近文件" })

-- 帮助文档
vim.keymap.set("n", "<leader>fh", function()
    Snacks.picker.help()
end, { desc = "搜索帮助" })

-- 文件浏览器
vim.keymap.set("n", "<leader>e", function()
    Snacks.explorer()
end, { desc = "打开文件浏览器" })

-- 通知历史
vim.keymap.set("n", "<leader>un", function()
    Snacks.notifier.show_history()
end, { desc = "通知历史" })

-- 手动打开 Dashboard
vim.keymap.set("n", "<leader>ud", function()
    Snacks.dashboard()
end, { desc = "打开 Dashboard" })

-- 平滑滚动开关
Snacks.toggle.scroll():map("<leader>us")

-- 缩进参考线开关
Snacks.toggle.indent():map("<leader>ui")
