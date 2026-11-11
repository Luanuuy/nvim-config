local gs = require("gitsigns")

gs.setup({
    signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
    },

    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,

    current_line_blame = false,
    auto_attach = true,

    on_attach = function(bufnr)
        local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, {
                buffer = bufnr,
                desc = desc,
            })
        end

        map("n", "<leader>gp", gs.preview_hunk, "预览变更")
        map("n", "<leader>gS", gs.stage_buffer, "暂存整个 Buffer")
        map("n", "<leader>gR", gs.reset_buffer, "还原整个 Buffer")
        map("n", "<leader>gb", gs.blame_line, "当前行提交信息")
        map("n", "<leader>gB", gs.toggle_current_line_blame, "行内 blame")
        map("n", "<leader>gD", gs.diffthis, "与索引对比")
        map("n", "<leader>ga", gs.stage_hunk, "暂存当前变更")
        map("n", "<leader>gr", gs.reset_hunk, "撤销当前变更")

        map("x", "<leader>ga", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "暂存选区变更")

        map("x", "<leader>gr", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "撤销选区变更")

        map("n", "]h", function()
            gs.nav_hunk("next")
        end, "下一个变更块")

        map("n", "[h", function()
            gs.nav_hunk("prev")
        end, "上一个变更块")
    end,
})
