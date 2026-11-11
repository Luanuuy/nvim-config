local map = vim.keymap.set

-- 打开配置目录
map("n", "<leader>fc", function()
    vim.cmd.edit({
        args = { vim.fn.stdpath("config") .. "/init.lua" },
    })
end, {
    desc = "编辑 Neovim 配置",
})

-- =========================================================
-- 编辑效率
-- =========================================================

-- 保存文件
map("n", "<leader>ws", "<cmd>write<CR>", { desc = "保存文件" })

-- 可视模式移动选中行(适配缩进)
-- map("x", "J", ":move '>+1<CR>gv=gv", { desc = "选中内容下移" })
-- map("x", "K", ":move '<-2<CR>gv=gv", { desc = "选中内容上移" })

-- 可视模式移动选中行(不适配缩进)
map("x", "J", ":move '>+1<CR>gv", { desc = "选中行向下移动" })
map("x", "K", ":move '<-2<CR>gv", { desc = "选中行向上移动" })

-- 半页滚动后保持光标居中
map("n", "<C-d>", "<C-d>zz", { desc = "向下半页并居中" })
map("n", "<C-u>", "<C-u>zz", { desc = "向上半页并居中" })

-- 清除搜索高亮
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "清除搜索高亮" })

-- 搜索结果跳转后保持光标居中
map("n", "n", "nzzzv", { desc = "下一个搜索结果" })
map("n", "N", "Nzzzv", { desc = "上一个搜索结果" })

-- =========================================================
-- 窗口管理
-- =========================================================

map("n", "<leader>q", "<cmd>quit<cr>", { desc = "关闭当前窗口" })
map("n", "<leader>x", "<cmd>x<cr>", { desc = "保存并退出" })
map("n", "<leader>wh", "<cmd>split<CR>", { desc = "水平分割窗口" })
map("n", "<leader>wv", "<cmd>vsplit<CR>", { desc = "垂直分割窗口" })
map("n", "<C-h>", "<C-w>h") -- 向左切换
map("n", "<C-j>", "<C-w>j") -- 向下切换
map("n", "<C-k>", "<C-w>k") -- 向上切换
map("n", "<C-l>", "<C-w>l") -- 向右切换
map("n", "<leader>wo", "<cmd>only<CR>", { desc = "仅保留当前窗口" })
map("n", "<leader>w=", "<C-w>=", { desc = "平衡窗口尺寸" })

-- =========================================================
-- Buffer 管理
-- =========================================================

map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "下一个 Buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "上一个 Buffer" })
map("n", "<leader>bd", function()
    Snacks.bufdelete()
end, { desc = "关闭 Buffer" })

-- =========================================================
-- LSP: v0.12 已自带 gra/grn/grr/gri/grt/grx/gO/K/gx
-- =========================================================

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),

    callback = function(event)
        local b = event.buf
        local function bmap(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = b, desc = desc })
        end

        bmap("n", "gd", vim.lsp.buf.definition, "转到定义")
        bmap("n", "<leader>cd", vim.diagnostic.open_float, "行内诊断")
    end,
})
