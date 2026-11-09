-- Lua Language Server
vim.lsp.config("lua_ls", {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },

    root_markers = {
        ".luarc.json",
        ".luarc.jsonc",
        ".git",
    },

    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },

            workspace = {
                library = {
                    vim.env.VIMRUNTIME,
                },
                checkThirdParty = false,
            },

            diagnostics = {
                globals = { "vim" },
            },

            telemetry = {
                enable = false,
            },
        },
    },
})

vim.lsp.enable("lua_ls")

-- JSON / JSONC Language Server
vim.lsp.config("json_ls", {
    cmd = {
        "vscode-json-language-server",
        "--stdio",
    },

    filetypes = {
        "json",
        "jsonc",
    },

    root_markers = {
        ".git",
        "package.json",
    },

    settings = {
        json = {
            validate = {
                enable = true,
            },

            schemas = require("schemastore").json.schemas(),
        },
    },
})

vim.lsp.enable("json_ls")

-- YAML Language Server
vim.lsp.config("yamlls", {
    cmd = {
        "yaml-language-server",
        "--stdio",
    },

    filetypes = {
        "yaml",
    },

    root_markers = {
        ".git",
    },

    settings = {
        yaml = {
            validate = true,
            completion = true,
            hover = true,

            -- 暂不启用 SchemaStore 自动关联
            schemaStore = {
                enable = false,
            },
        },
    },
})

vim.lsp.enable("yamlls")

-- Python Language Server (Pyright)
vim.lsp.config("pyright", {
    cmd = {
        "pyright-langserver",
        "--stdio",
    },

    filetypes = {
        "python",
    },

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

vim.lsp.enable("pyright")
