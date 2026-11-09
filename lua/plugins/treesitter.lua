-- Windows 环境下优先使用已安装的 GCC
if vim.fn.has("win32") == 1 and not vim.env.CC and vim.fn.executable("gcc") == 1 then
    vim.env.CC = "gcc" -- 使用 w64devkit GCC 编译 Tree-sitter 解析器
end

-- 需要启用 Tree-sitter 高亮的文件类型
local supported_filetypes = {
    lua = true,
    python = true,
    sh = true,
    bash = true,
    json = true,
    yaml = true,
    toml = true,
    javascript = true,
    typescript = true,
}

-- 自动启用 Tree-sitter 语法高亮
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("UserTreesitterHighlight", { clear = true }),
    callback = function(args)
        local ft = vim.bo[args.buf].filetype

        if not supported_filetypes[ft] then
            return
        end

        local ok, err = pcall(vim.treesitter.start, args.buf)

        if not ok then
            vim.notify(
                "Tree-sitter 启动失败 (" .. ft .. "): " .. tostring(err),
                vim.log.levels.WARN
            )
        end
    end,
})
