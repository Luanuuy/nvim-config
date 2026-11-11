-- Lua Language Server
vim.lsp.config("lua_ls", {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },

    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
                -- library = { vim.env.VIMRUNTIME }, -- 轻量加载
                library = vim.api.nvim_get_runtime_file("", true), -- 全量加载
                checkThirdParty = false, -- 第三方库检测
            },

            -- 声明合法的全局变量
            diagnostics = {
                globals = { "vim", "Snacks", "MiniIcons" },
            },
            telemetry = { enable = false }, -- 关闭遥测
        },
    },
})

-- JSON / JSONC Language Server
vim.lsp.config("jsonls", {
    cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json", "jsonc" },
    root_markers = { ".git", "package.json" },

    settings = {
        json = {
            validate = { enable = true },
            schemas = require("schemastore").json.schemas(),
        },
    },
})

-- YAML Language Server
-- 用 SchemaStore 的 YAML 目录，并显式清空内置 schemaStore url
vim.lsp.config("yamlls", {
    cmd = { "yaml-language-server", "--stdio" },
    filetypes = { "yaml" },
    root_markers = { ".git" },

    settings = {
        yaml = {
            validate = true,
            completion = true,
            hover = true,

            -- 暂不启用 SchemaStore 自动关联
            schemaStore = { enable = false, url = "" },
            schemas = require("schemastore").yaml.schemas(),
        },
    },
})

-- Python Language Server (Pyright)
vim.lsp.config("pyright", {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = {
        "pyrightconfig.json",
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        ".git",
    },

    settings = {
        python = {
            analysis = {
                typeCheckingMode = "standard",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
            },
        },
    },
})

vim.lsp.enable({ "lua_ls", "jsonls", "yamlls", "pyright" })
