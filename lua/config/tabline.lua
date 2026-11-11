local M = {}

local function clip(text, width)
    if vim.fn.strdisplaywidth(text) <= width then
        return text
    end

    while vim.fn.strdisplaywidth(text) > width - 1 do
        text = vim.fn.strcharpart(text, 0, vim.fn.strchars(text) - 1)
    end
    return text .. "…"
end

function M.click(buf, _, button)
    if button ~= "l" or not vim.api.nvim_buf_is_valid(buf) or not vim.bo[buf].buflisted then
        return
    end

    vim.schedule(function()
        if vim.api.nvim_buf_is_valid(buf) then
            vim.cmd.buffer({ args = { tostring(buf) } })
        end
    end)
end

function M.render()
    local buffers = {}
    local current = vim.api.nvim_get_current_buf()
    local index = 1

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local bt = vim.bo[buf].buftype
        if vim.bo[buf].buflisted and (bt == "" or bt == "terminal") then
            buffers[#buffers + 1] = buf
            if buf == current then
                index = #buffers
            end
        end
    end

    if #buffers == 0 then
        return "%#TabLineFill#"
    end

    -- 每个标签最多约 26 列，为两侧省略提示预留空间。
    local count = math.max(1, math.floor((vim.o.columns - 8) / 26))
    count = math.min(count, #buffers)

    local first = math.max(1, index - math.floor(count / 2))
    first = math.min(first, #buffers - count + 1)
    local last = first + count - 1

    local parts = { "%#TabLineFill#" }
    if first > 1 then
        parts[#parts + 1] = " ‹ "
    end

    for i = first, last do
        local buf = buffers[i]
        local name = vim.api.nvim_buf_get_name(buf)

        if vim.bo[buf].buftype == "terminal" then
            name = "[终端]"
        elseif name == "" then
            name = "[未命名]"
        else
            name = vim.fn.fnamemodify(name, ":t")
        end

        -- 清理控制字符，并转义 tabline 格式字符 %。
        name = name:gsub("%c", " ")
        local suffix = vim.bo[buf].modified and " +" or ""
        local label = (
            clip(("%d:%s"):format(buf, name), 22 - vim.fn.strdisplaywidth(suffix)) .. suffix
        ):gsub("%%", "%%%%")

        parts[#parts + 1] = buf == current and "%#TabLineSel#" or "%#TabLine#"
        parts[#parts + 1] = ("%%%d@v:lua.UserBufferTabline.click@ %s %%T"):format(buf, label)
    end

    parts[#parts + 1] = "%#TabLineFill#"
    if last < #buffers then
        parts[#parts + 1] = " › "
    end
    parts[#parts + 1] = "%="
    return table.concat(parts)
end

_G.UserBufferTabline = M

vim.opt.showtabline = 2
vim.opt.tabline = "%!v:lua.UserBufferTabline.render()"

vim.api.nvim_create_autocmd({
    "BufAdd",
    "BufEnter",
    "BufDelete",
    "BufFilePost",
    "BufModifiedSet",
    "VimResized",
}, {
    group = vim.api.nvim_create_augroup("UserBufferTabline", { clear = true }),
    callback = function()
        vim.schedule(function()
            vim.cmd.redrawtabline()
        end)
    end,
})
