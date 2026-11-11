local markview = require("markview")

-- ============================================
-- 1. Catppuccin 自定义高亮
-- ============================================

local function set_highlights()
    local p = require("catppuccin.palettes").get_palette("mocha")
    local hl = vim.api.nvim_set_hl

    -- 六级标题
    local headings = {
        { fg = p.mauve, bg = p.surface0 },
        { fg = p.blue, bg = p.surface0 },
        { fg = p.green },
        { fg = p.yellow },
        { fg = p.peach },
        { fg = p.lavender },
    }

    for i, style in ipairs(headings) do
        hl(0, "CustomMdH" .. i, {
            fg = style.fg,
            bg = style.bg,
            bold = i <= 2,
        })
    end

    -- 代码块
    hl(0, "CustomMdCode", {
        bg = p.mantle,
    })
    hl(0, "CustomMdCodeBorder", {
        fg = p.surface2,
        bg = p.mantle,
    })
    hl(0, "CustomMdCodeInfo", {
        fg = p.sapphire,
        bg = p.mantle,
        italic = true,
    })

    -- 表格
    hl(0, "CustomMdTableHeader", {
        fg = p.blue,
        bold = true,
    })
    hl(0, "CustomMdTableBorder", {
        fg = p.surface2,
    })

    -- GitHub Callout
    local callouts = {
        Note = p.blue,
        Tip = p.green,
        Important = p.mauve,
        Warning = p.yellow,
        Caution = p.red,
    }

    for name, color in pairs(callouts) do
        hl(0, "CustomMd" .. name, {
            fg = color,
            bold = true,
        })
    end
end

set_highlights()

-- 切换主题时重新生成高亮
vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("UserMarkdownHighlights", { clear = true }),
    callback = function()
        vim.schedule(set_highlights)
    end,
})

-- ============================================
-- 2. 插件配置
-- ============================================

markview.setup({
    preview = {
        enable = true,
        enable_hybrid_mode = true,

        icon_provider = "mini", -- 可选："mini" / "internal"
        map_gx = false,

        filetypes = { "markdown" },
        ignore_buftypes = { "nofile" },

        debounce = 150,
        max_buf_lines = 500,
        draw_range = { vim.o.lines, vim.o.lines },

        modes = { "n", "no", "c", "i" },
        hybrid_modes = { "n", "i" },

        linewise_hybrid_mode = false,
        edit_range = { 0, 0 },

        splitview_winopts = {
            split = "right",
        },
    },

    markdown = {
        enable = true,

        -- 六级标题
        headings = {
            enable = true,
            shift_width = 0,

            heading_1 = {
                style = "icon",
                icon = "󰎤  ",
                hl = "CustomMdH1",
            },
            heading_2 = {
                style = "icon",
                icon = "󰎧  ",
                hl = "CustomMdH2",
            },
            heading_3 = {
                style = "icon",
                icon = "󰎪  ",
                hl = "CustomMdH3",
            },
            heading_4 = {
                style = "icon",
                icon = "󰎭  ",
                hl = "CustomMdH4",
            },
            heading_5 = {
                style = "icon",
                icon = "󰎱  ",
                hl = "CustomMdH5",
            },
            heading_6 = {
                style = "icon",
                icon = "󰎳  ",
                hl = "CustomMdH6",
            },
        },

        -- 代码块背景与边界
        code_blocks = {
            enable = true,
            style = "block",

            min_width = 40,
            pad_amount = 1,
            pad_char = " ",

            label_direction = "right",
            sign = false,

            border_hl = "CustomMdCodeBorder",
            info_hl = "CustomMdCodeInfo",

            default = {
                block_hl = "CustomMdCode",
                pad_hl = "CustomMdCode",
            },
        },

        -- 表格
        tables = {
            enable = true,
            strict = false,

            block_decorator = true,
            use_virt_lines = false,

            parts = {
                top = { "╭", "─", "╮", "┬" },
                header = { "│", "│", "│" },
                separator = { "├", "─", "┤", "┼" },
                row = { "│", "│", "│" },
                bottom = { "╰", "─", "╯", "┴" },

                overlap = { "┝", "━", "┥", "┿" },

                align_left = "╼",
                align_right = "╾",
                align_center = { "╴", "╶" },
            },

            hl = {
                top = {
                    "CustomMdTableHeader",
                    "CustomMdTableHeader",
                    "CustomMdTableHeader",
                    "CustomMdTableHeader",
                },
                header = {
                    "CustomMdTableHeader",
                    "CustomMdTableHeader",
                    "CustomMdTableHeader",
                },
                separator = {
                    "CustomMdTableHeader",
                    "CustomMdTableHeader",
                    "CustomMdTableHeader",
                    "CustomMdTableHeader",
                },
                row = {
                    "CustomMdTableBorder",
                    "CustomMdTableBorder",
                    "CustomMdTableBorder",
                },
                bottom = {
                    "CustomMdTableBorder",
                    "CustomMdTableBorder",
                    "CustomMdTableBorder",
                    "CustomMdTableBorder",
                },
            },
        },

        -- GitHub Callout
        block_quotes = {
            enable = true,
            wrap = false,

            default = {
                border = "▋",
                hl = "MarkviewBlockQuoteDefault",
            },

            ["NOTE"] = {
                preview = "󰋽 Note",
                hl = "CustomMdNote",
                border = "▋",
                title = true,
            },

            ["TIP"] = {
                preview = "󰌶 Tip",
                hl = "CustomMdTip",
                border = "▋",
                title = true,
            },

            ["IMPORTANT"] = {
                preview = "󰅾 Important",
                hl = "CustomMdImportant",
                border = "▋",
                title = true,
            },

            ["WARNING"] = {
                preview = "󰀪 Warning",
                hl = "CustomMdWarning",
                border = "▋",
                title = true,
            },

            ["CAUTION"] = {
                preview = "󰳦 Caution",
                hl = "CustomMdCaution",
                border = "▋",
                title = true,
            },
        },
    },

    markdown_inline = {
        enable = true,
    },
})

-- ============================================
-- 3. Markdown 文件局部设置
-- ============================================

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("UserMarkdown", { clear = true }),
    pattern = "markdown",
    callback = function()
        vim.opt_local.expandtab = true
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.conceallevel = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.wrap = false
    end,
})

-- ============================================
-- 4. 快捷键
-- ============================================

local map = vim.keymap.set
map("n", "<leader>mT", "<cmd>Markview<CR>", {
    desc = "全局切换预览",
})

map("n", "<leader>mt", "<cmd>Markview toggle<cr>", {
    desc = "切换当前 Buffer 预览",
})

map("n", "<leader>mh", "<cmd>Markview hybridToggle<cr>", {
    desc = "切换 Hybrid",
})

map("n", "<leader>ms", "<cmd>Markview splitToggle<cr>", {
    desc = "分屏预览",
})

map("n", "<leader>ml", "<cmd>Markview linewiseToggle<cr>", {
    desc = "切换行级 Hybrid",
})
