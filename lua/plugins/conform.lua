local conform = require("conform")

conform.setup({
    -- 按文件类型指定格式化工具
    formatters_by_ft = {
        lua = { "stylua" },

        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },

        -- Markdown 仅手动格式化
        markdown = { "prettier" },
    },

    -- 禁止使用 LSP 格式化
    default_format_opts = {
        lsp_format = "never",
    },

    -- 保存时自动格式化
    format_on_save = function(bufnr)
        local ft = vim.bo[bufnr].filetype

        local enabled = {
            lua = true,
            json = true,
            jsonc = true,
            yaml = true,
        }

        if not enabled[ft] then
            return nil
        end

        return {
            timeout_ms = 3000,
            lsp_format = "never",
        }
    end,

    notify_on_error = true,
})

-- 手动格式化当前文件
vim.keymap.set("n", "<leader>cf", function()
    conform.format({
        async = false,
        lsp_format = "never",
    })
end, {
    desc = "格式化 buffer",
    silent = true,
})
