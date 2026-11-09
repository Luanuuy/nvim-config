local map = vim.keymap.set

-- 打开配置目录
map("n", "<leader>fc", function()
    vim.cmd.edit(vim.fn.stdpath("config") .. "/init.lua")
end, {
    desc = "编辑 Neovim 配置",
})

-- =========================================================
-- 编辑效率
-- =========================================================

-- 保存文件
map("n", "<leader>ws", "<cmd>write<CR>", {
    desc = "保存文件",
})

-- 可视模式移动选中行(适配缩进)
--[[
map("x", "J", ":move '>+1<CR>gv=gv", {
    desc = "选中内容下移",
})

map("x", "K", ":move '<-2<CR>gv=gv", {
    desc = "选中内容上移",
})
]]

-- 可视模式移动选中行(不适配缩进)
map("x", "J", ":move '>+1<CR>gv", {
    desc = "选中行向下移动",
})

map("x", "K", ":move '<-2<CR>gv", {
    desc = "选中行向上移动",
})

-- 半页滚动后保持光标居中
map("n", "<C-d>", "<C-d>zz", {
    desc = "向下半页并居中",
})

map("n", "<C-u>", "<C-u>zz", {
    desc = "向上半页并居中",
})

-- 清除搜索高亮
map("n", "<Esc>", "<cmd>nohlsearch<CR>", {
    desc = "清除搜索高亮",
})

-- 搜索结果跳转后保持光标居中
map("n", "n", "nzzzv", {
    desc = "下一个搜索结果",
})

map("n", "N", "Nzzzv", {
    desc = "上一个搜索结果",
})

-- =========================================================
-- 窗口管理
-- =========================================================

-- 关闭当前窗口
map("n", "<leader>q", "<cmd>close<cr>", {
    desc = "关闭当前窗口",
})

-- 保存当前文件并退出当前窗口
map("n", "<leader>x", "<cmd>x<cr>", {
    desc = "保存修改并退出",
})

-- 分割窗口
map("n", "<leader>wh", "<cmd>split<CR>", {
    desc = "水平分割窗口",
})

map("n", "<leader>wv", "<cmd>vsplit<CR>", {
    desc = "垂直分割窗口",
})

-- 窗口切换
map("n", "<C-h>", "<C-w>h") -- 向左切换
map("n", "<C-j>", "<C-w>j") -- 向下切换
map("n", "<C-k>", "<C-w>k") -- 向上切换
map("n", "<C-l>", "<C-w>l") -- 向右切换

-- 仅保留当前窗口
map("n", "<leader>wo", "<cmd>only<CR>", {
    desc = "仅保留当前窗口",
})

-- 平衡窗口尺寸
map("n", "<leader>w=", "<C-w>=", {
    desc = "平衡窗口尺寸",
})

-- =========================================================
-- Buffer 管理
-- =========================================================

-- 切换 Buffer
map("n", "<S-h>", "<cmd>bprevious<CR>", {
    desc = "上一个 Buffer",
})

map("n", "<S-l>", "<cmd>bnext<CR>", {
    desc = "下一个 Buffer",
})

-- 关闭当前 Buffer
map("n", "<leader>bd", "<cmd>bdelete<CR>", {
    desc = "关闭 Buffer",
})

-- =========================================================
-- 诊断导航
-- =========================================================

-- 跳转到下一个诊断
map("n", "]d", function()
    vim.diagnostic.jump({
        count = 1,
        float = false,
    })
end, { desc = "下一个诊断" })

-- 跳转到上一个诊断
map("n", "[d", function()
    vim.diagnostic.jump({
        count = -1,
        float = false,
    })
end, { desc = "上一个诊断" })

-- 诊断详情
map("n", "<leader>cd", function()
    vim.diagnostic.open_float({
        scope = "line",
        border = "rounded",
        source = "if_many",
        focusable = true,
        focus = false,
        close_events = {
            "CursorMoved",
            "InsertEnter",
            "BufHidden",
        },
    })
end, { desc = "显示行内诊断" })

-- =========================================================
-- LSP 常用操作
-- =========================================================

local lsp_group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
    group = lsp_group,

    callback = function(event)
        local buffer = event.buf

        -- 跳转到符号定义
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
            buffer = buffer,
            desc = "转到定义",
        })

        -- 重命名符号
        vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, {
            buffer = buffer,
            desc = "重命名",
        })

        -- Code Action
        vim.keymap.set({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, {
            buffer = buffer,
            desc = "代码操作",
        })
    end,
})

-- =========================================================
-- Git 操作
-- =========================================================

-- 查看 Git 状态
map("n", "<leader>gs", function()
    require("snacks").picker.git_status()
end, { desc = "查看状态" })

-- 查看 Git 提交历史
map("n", "<leader>gl", function()
    require("snacks").picker.git_log()
end, { desc = "提交历史" })

-- 查看 Git 差异
map("n", "<leader>gd", function()
    require("snacks").picker.git_diff()
end, { desc = "查看差异" })
