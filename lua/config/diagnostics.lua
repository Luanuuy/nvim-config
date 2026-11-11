local severity = vim.diagnostic.severity

vim.diagnostic.config({
    -- 在行尾显示诊断信息
    virtual_text = {
        spacing = 2,
        prefix = "●",
        source = "if_many", -- 仅出现多个诊断来源才显示来源
        severity = { min = severity.WARN }, -- 	仅显示 WARN 及以上级别
    },

    -- 可选：把当前行诊断换成虚拟行（比虚文本更易读）
    virtual_lines = false,

    -- 诊断位置高亮
    underline = true,

    -- 插入模式下不更新诊断
    update_in_insert = false,

    -- 优先显示更严重的诊断
    severity_sort = true,

    -- 允许浮窗获取键盘焦点
    float = { focusable = true },

    -- 诊断跳转行为
    jump = {
        wrap = true, -- 循环跳转
        on_jump = function(d)
            if not d then
                return
            end
            vim.diagnostic.open_float({
                scope = "line",
            })
        end,
    },
})
