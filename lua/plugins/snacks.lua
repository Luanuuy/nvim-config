local Snacks = require("snacks")

Snacks.setup({
    -- 文件、内容及 Buffer 搜索
    picker = {
        enabled = true,

        -- 搜索窗口布局
        layout = {
            -- 宽窗口：Telescope 风格; 窄窗口：Vertical 风格
            preset = function()
                return vim.o.columns >= 120 and "telescope" or "vertical"
            end,
        },

        -- 搜索结果格式
        formatters = {
            -- 文件名优先显示
            file = { filename_first = true },
        },

        -- 各搜索来源的独立配置
        sources = {
            -- 文件搜索
            files = {
                hidden = true, -- 包含隐藏文件
                ignored = false, -- 遵守忽略规则
            },

            -- 全文搜索
            grep = {
                hidden = true, -- 包含隐藏文件
                ignored = false, -- 遵守忽略规则
            },

            -- 资源管理器
            explorer = {
                hidden = true, -- 包含隐藏文件
                ignored = false, -- 遵守忽略规则
                tree = true, -- 目录树模式
                follow_file = true, -- 跟踪正在编辑的文件
                watch = true, -- 自动监听文件系统变化
                auto_close = false, -- 打开文件后保留 Explorer
                git_status = true, -- 在文件树中显示 Git 状态
                git_untracked = true,
                diagnostics = true, -- 显示LSP 诊断信息

                -- 侧边栏布局
                layout = {
                    preset = "sidebar",
                    preview = false,

                    layout = {
                        position = "left",
                        width = 32,
                        min_width = 30,
                    },
                },
            },
        },
    },

    -- 浮动窗口
    styles = {
        -- 通知窗口
        notification = {
            wo = { wrap = true },
        },

        -- 输入弹窗
        input = {
            -- 固定宽度
            width = 60,

            -- 距离编辑器顶部 2 行
            relative = "editor",
            row = 2,

            -- 标题居中
            title_pos = "center",
        },

        -- 通知历史窗口
        notification_history = {
            width = 0.65,
            height = 0.6,
        },
    },

    -- 通知管理
    notifier = {
        enabled = true,
        timeout = 3500, -- 默认显示 3.5 秒
        style = "compact", -- 紧凑风格
        top_down = true, -- 从顶部向下排列通知

        -- 通知窗口宽度
        width = {
            min = 32,
            max = 0.4,
        },

        -- 通知窗口高度
        height = {
            min = 1,
            max = 0.5,
        },

        -- 距离编辑器边缘的间距
        margin = {
            top = 1,
            right = 1,
            bottom = 0,
        },

        padding = true, -- 左右内边距
        sort = { "level", "added" }, -- 按等级和产生时间排序
        level = vim.log.levels.TRACE, -- 保留所有等级的通知
    },

    -- 输入弹窗
    input = {
        enabled = true,
        icon_pos = "left", -- 标记显示在左侧
        prompt_pos = "title", -- 提示文字显示在标题栏
        expand = true, -- 根据内容扩展输入框
        win = { style = "input" }, -- 使用 Snacks 内置 input 窗口样式
    },

    -- 文件浏览器 Explorer
    explorer = {
        enabled = true,
        replace_netrw = true, -- 使用 Snacks Explorer 替代 netrw
        trash = true, -- 删除文件时使用系统回收站
    },

    -- 启动界面 Dashboard
    dashboard = {
        enabled = true,
        width = 56, -- 内容显示宽度

        -- 标题和快捷操作
        preset = {
            header = [[
||\    ||
||\\   ||
|| \\  ||
||  \\ ||
||   \\||
EDIT · BUILD · CREATE
        ]],

            keys = {
                {
                    icon = " ",
                    key = "f",
                    desc = "查找文件",
                    action = function()
                        Snacks.picker.files()
                    end,
                },
                {
                    icon = " ",
                    key = "g",
                    desc = "全文搜索",
                    action = function()
                        Snacks.picker.grep()
                    end,
                },
                {
                    icon = " ",
                    key = "b",
                    desc = "Buffer 列表",
                    action = function()
                        Snacks.picker.buffers()
                    end,
                },
                {
                    icon = "󰒲 ",
                    key = "r",
                    desc = "最近文件",
                    action = function()
                        Snacks.picker.recent()
                    end,
                },
                {
                    icon = " ",
                    key = "c",
                    desc = "编辑 Neovim 配置",
                    action = function()
                        vim.cmd.edit({
                            args = { vim.fn.stdpath("config") .. "/init.lua" },
                        })
                    end,
                },
                {
                    icon = "󰉋 ",
                    key = "e",
                    desc = "文件浏览器",
                    action = function()
                        Snacks.explorer()
                    end,
                },
                {
                    icon = " ",
                    key = "n",
                    desc = "新建文件",
                    action = ":ene | startinsert",
                },
            },
        },

        -- Dashboard 布局
        sections = {
            -- 顶部标题
            { section = "header" },

            -- 快捷操作
            {
                section = "keys",
                gap = 1,
                padding = 1,
            },

            -- 最近打开的文件
            {
                title = "Recent Files",
                section = "recent_files",
                limit = 5,
                indent = 2,
                padding = 1,
            },
        },
    },

    -- 平滑滚动
    scroll = {
        enabled = true,

        -- 普通滚动动画
        animate = {
            duration = {
                step = 10,
                total = 120,
            },

            easing = "linear",
        },

        -- 连续滚动时使用更快的动画
        animate_repeat = {
            delay = 100,

            duration = {
                step = 5,
                total = 50,
            },

            easing = "linear",
        },
    },

    -- 缩进参考线
    indent = {
        enabled = true,
        char = "│", -- 使用细竖线
        only_scope = false, -- 显示所有缩进层级
        only_current = false, -- 所有普通编辑窗口均显示缩进线
        hl = "SnacksIndent", -- 沿用主题高亮组

        -- 当前代码作用域
        scope = {
            enabled = true,
            char = "│", -- 使用相同的竖线字符
            underline = false, -- 不绘制作用域起始下划线
            only_current = true, -- 只在当前窗口突出作用域
            hl = "SnacksIndentScope", -- 使用独立高亮组
        },

        animate = { enabled = true }, -- 作用域动画
        chunk = { enabled = false }, -- 代码块边框
    },

    -- Toggle 状态切换
    toggle = {
        which_key = true, -- 与 which-key 集成
        notify = true, -- 切换时显示 Snacks 通知

        -- which-key 状态颜色
        color = {
            enabled = "green",
            disabled = "yellow",
        },

        -- 动态操作说明
        wk_desc = {
            enabled = "关闭 ",
            disabled = "开启 ",
        },
    },

    -- 暂不使用的模块
    image = { enabled = false }, -- 终端图片渲染
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

-- 在 Explorer 中定位当前文件
vim.keymap.set("n", "<leader>fe", function()
    Snacks.explorer.reveal()
end, { desc = "定位当前文件" })

-- 通知历史
vim.keymap.set("n", "<leader>un", function()
    Snacks.notifier.show_history()
end, { desc = "通知历史" })

-- 手动打开 Dashboard
vim.keymap.set("n", "<leader>ud", function()
    Snacks.dashboard()
end, { desc = "开始页面" })

-- 查看 Git 状态
vim.keymap.set("n", "<leader>gs", function()
    Snacks.picker.git_status()
end, { desc = "查看状态" })

-- 查看 Git 提交历史
vim.keymap.set("n", "<leader>gl", function()
    Snacks.picker.git_log()
end, { desc = "提交历史" })

-- 查看 Git 差异
vim.keymap.set("n", "<leader>gd", function()
    Snacks.picker.git_diff()
end, { desc = "查看差异" })

-- 平滑滚动开关
Snacks.toggle.scroll():map("<leader>us")

-- 缩进参考线开关
Snacks.toggle.indent():map("<leader>ui")
