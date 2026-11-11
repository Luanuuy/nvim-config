local conform = require("conform")

conform.setup({
    -- 按文件类型指定格式化工具
    formatters_by_ft = {
        lua = { "stylua" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" }, -- 仅手动格式化
        sh = { "shfmt" }, -- 可选
        python = { "ruff_format", "black", stop_after_first = true }, -- 可选
    },

    -- 禁止使用 LSP 格式化
    default_format_opts = { lsp_format = "never" },

    -- 保存时自动格式化
    format_on_save = function(bufnr)
        local enabled = {
            lua = true,
            json = true,
            jsonc = true,
            yaml = true,
        }

        if not enabled[vim.bo[bufnr].filetype] then
            return nil
        end

        return { timeout_ms = 3000 }
    end,

    notify_on_error = true,
})

-- 手动格式化当前 Buffer
vim.keymap.set("n", "<leader>cf", function()
    conform.format({
        async = false,
        lsp_format = "never",
    })
end, {
    desc = "格式化 buffer",
    silent = true,
})
