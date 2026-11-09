require("flash").setup({
    modes = {
        search = {
            enabled = false,
        },
        char = {
            enabled = false,
        },
    },
})

vim.keymap.set({ "n", "x", "o" }, "s", function()
    require("flash").jump()
end, {
    desc = "Flash 快速跳转",
})

vim.keymap.set({ "n", "o" }, "S", function()
    require("flash").treesitter()
end, {
    desc = "Flash Treesitter 选择",
})
