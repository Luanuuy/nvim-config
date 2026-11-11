-- Windows 环境下优先使用已安装的 GCC
if vim.fn.has("win32") == 1 and not vim.env.CC and vim.fn.executable("gcc") == 1 then
    vim.env.CC = "gcc" -- 使用 w64devkit GCC 编译 Tree-sitter 解析器
end

-- 注册解析器映射
vim.treesitter.language.register("bash", { "sh" })
vim.treesitter.language.register("json", { "jsonc" })
vim.treesitter.language.register("javascript", { "javascriptreact" })
vim.treesitter.language.register("tsx", { "typescriptreact" })

-- 允许启用 Tree-sitter 高亮的文件类型
local supported = {
    lua = true,
    python = true,
    sh = true,
    bash = true,
    json = true,
    jsonc = true,
    yaml = true,
    toml = true,
    javascript = true,
    javascriptreact = true,
    typescript = true,
    typescriptreact = true,
}

-- 创建统一的自动命令组
local group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true })

local function get_language(buf)
    -- 不在允许列表中的文件类型直接跳过
    if not supported[vim.bo[buf].filetype] then
        return
    end

    -- 获取解析器名称
    local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)

    -- 解析器不存在时跳过，不产生警告
    if lang and vim.treesitter.language.add(lang) then
        return lang
    end
end

-- 自动启用 Tree-sitter 语法高亮
vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function(args)
        local lang = get_language(args.buf)
        if lang then
            vim.treesitter.start(args.buf, lang)
        end
    end,
})

-- 窗口选项：进入已有 Buffer 时也要处理。
vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
    group = group,
    callback = function(args)
        -- 折叠选项作用于窗口，确保当前窗口显示目标缓冲区
        if vim.api.nvim_get_current_buf() ~= args.buf then
            return
        end

        if get_language(args.buf) then
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.wo.foldmethod = "expr"
        elseif vim.wo.foldexpr == "v:lua.vim.treesitter.foldexpr()" then
            vim.wo.foldmethod = "manual"
            vim.wo.foldexpr = "0"
        end
    end,
})
