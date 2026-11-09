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

        -- 预览当前变更块
        map("n", "<leader>gp", gs.preview_hunk, "预览变更")

        -- 暂存当前变更块
        map("n", "<leader>ga", gs.stage_hunk, "暂存变更")

        -- 撤销当前变更块
        map("n", "<leader>gr", gs.reset_hunk, "撤销变更")

        -- 当前行 Git blame
        map("n", "<leader>gb", gs.blame_line, "当前行提交信息")

        -- 上一个 / 下一个变更块
        map("n", "]h", function()
            gs.nav_hunk("next")
        end, "下一个变更块")

        map("n", "[h", function()
            gs.nav_hunk("prev")
        end, "上一个变更块")
    end,
})
