# Neovim 配置

面向 **Windows 11 + Windows Terminal + PowerShell 7** 的轻量化 Neovim 配置。使用 **Neovim 0.12** 原生 `vim.pack` 管理插件，直接使用内置 LSP API，不依赖 Lazy.nvim、Mason 或 nvim-lspconfig。

## 主要功能

| 类别 | 组件 / 功能 |
| --- | --- |
| 主题 | Catppuccin Mocha，透明背景 |
| Markdown | markview.nvim：标题、表格、代码块与 Callout 预览 |
| 文件搜索与工具 | Snacks.nvim：Picker、Explorer、Dashboard、通知等 |
| 编辑增强 | Flash、nvim-surround、which-key |
| Git | Gitsigns、Snacks Git Picker |
| 补全 | blink.cmp：LSP、Buffer、Path；纯 Lua 模糊匹配 |
| 语法解析 | nvim-treesitter `main` 分支 |
| LSP | LuaLS、JSON Language Server、YAML Language Server、Pyright |
| 格式化 | Conform.nvim 调用 StyLua 与 Prettier |

## 目录结构

```text
nvim/
├── init.lua
├── lua/
│   ├── config/
│   │   ├── options.lua
│   │   ├── diagnostics.lua
│   │   ├── keymaps.lua
│   │   └── plugins.lua
│   └── plugins/
│       ├── blink.lua
│       ├── catppuccin.lua
│       ├── conform.lua
│       ├── flash.lua
│       ├── gitsigns.lua
│       ├── lsp.lua
│       ├── markview.lua
│       ├── snacks.lua
│       ├── surround.lua
│       ├── treesitter.lua
│       └── which-key.lua
├── nvim-pack-lock.json
├── stylua.toml
├── .prettierrc.json
└── .gitignore
```

## 环境要求

### 基础工具

- **Neovim 0.12**（该配置使用 `vim.pack` 和 Neovim 内置 LSP 配置 API）。
- Git（插件克隆及版本管理）。
- ripgrep (`rg`) 与 fd (`fd`)（Snacks Picker 文件搜索和全文搜索）。
- 支持所用图标的 Nerd Font（推荐，用于 Markdown/界面图标）。

### LSP 与格式化工具

| 命令 | 用途 | 安装来源示例 |
| --- | --- | --- |
| `lua-language-server` | Lua LSP | Lua Language Server |
| `vscode-json-language-server` | JSON / JSONC LSP | npm 包 `vscode-langservers-extracted` |
| `yaml-language-server` | YAML LSP | npm 包 `yaml-language-server` |
| `pyright-langserver` | Python LSP | npm 包 `pyright` |
| `stylua` | Lua 格式化 | StyLua |
| `prettier` | JSON / JSONC / YAML / Markdown 格式化 | npm 包 `prettier` |

已经安装 Node.js/npm 的环境，可安装以下 npm 工具：

```powershell
npm install -g vscode-langservers-extracted yaml-language-server pyright prettier
```

Lua Language Server 和 StyLua 需要单独安装，并确保对应命令可以在 `PATH` 中找到。

### Tree-sitter 解析器编译

需要 `tree-sitter` CLI（建议 0.26.1 或更新版本）、`tar`、`curl` 和 C 编译器。当前 Windows 环境使用 **w64devkit GCC**。需要编译解析器时，请确保 `gcc` 在 `PATH` 中；`treesitter.lua` 只在适合的 Windows 环境下设置 `CC=gcc`，不会覆盖已经存在的 `CC`。

在 PowerShell 中检查外部工具：

```powershell
$commands = @(
    'nvim', 'git', 'rg', 'fd',
    'lua-language-server',
    'vscode-json-language-server',
    'yaml-language-server',
    'pyright-langserver',
    'stylua', 'prettier',
    'tree-sitter', 'gcc', 'tar', 'curl'
)

foreach ($command in $commands) {
    $found = Get-Command $command -ErrorAction SilentlyContinue
    '{0,-30} {1}' -f $command, $(if ($found) { 'OK' } else { 'MISSING' })
}
```

某些工具只在使用对应功能时才需要；例如 GCC 主要用于解析器的安装或更新。

## 全新 Windows 环境恢复

1. 安装 Neovim、Git 和所需外部工具，配置 `PATH`。
2. 将这个仓库克隆或复制到 `$env:LOCALAPPDATA\nvim`，确保其中直接存在 `init.lua`（避免多嵌套一层 `nvim`）。例如：

   ```powershell
   git clone <你的仓库地址> "$env:LOCALAPPDATA\nvim"
   ```

   如果不使用远程仓库，也可以直接把备份中的配置目录复制到相同位置。
3. 启动 Neovim。`vim.pack.add()` 会尝试安装缺失的插件；`nvim-pack-lock.json` 应与配置一起保留，以恢复相应修订。
4. 安装 Tree-sitter 解析器。在 Neovim 内执行：

   ```vim
   :lua require('nvim-treesitter').install({ 'bash', 'javascript', 'json', 'python', 'regex', 'toml', 'typescript', 'yaml' })
   ```

5. 安装完成后重新启动 Neovim，依次检查：

   ```vim
   :checkhealth vim.pack
   :checkhealth nvim-treesitter
   :checkhealth vim.lsp
   :checkhealth conform
   :checkhealth snacks
   ```

6. 打开 Lua、Python、JSON、YAML、Markdown 文件，验证 LSP、补全、格式化和 Markdown 预览。`Snacks.image` 与 `lazygit` 的可选依赖提示不代表当前启用功能异常。

> 注意：Git 仓库包含配置和插件锁文件，**不包含** `nvim-data` 中已安装的插件、编译后的解析器、系统字体及外部 LSP/格式化程序。它们需要在目标设备上重新安装。

## 常用快捷键

Leader 键为 `<Space>`。

| 快捷键 | 功能 |
| --- | --- |
| `<Space>e` | Snacks 文件浏览器 |
| `<Space>ff` / `<Space>fg` | 查找文件 / 全文搜索 |
| `<Space>fb` / `<Space>fr` | 查找 Buffer / 最近文件 |
| `<Space>fc` | 编辑 `init.lua` |
| `<Space>cf` | 手动格式化当前 Buffer |
| `<Space>cd` | 查看当前行诊断 |
| `gd` | 转到定义（LSP 附加时） |
| `<Space>cr` / `<Space>ca` | 重命名 / Code Action（LSP 附加时） |
| `<Space>mt` | 切换 Markdown 预览 |
| `<Space>gs` / `<Space>gl` / `<Space>gd` | Git 状态 / 日志 / 差异 |
| `<Space>ws` | 保存文件 |
| `<Space>wv` / `<Space>wh` | 垂直 / 水平分屏 |
| `<Space>bd` | 关闭 Buffer |

完整快捷键可通过 which-key 菜单查看；Gitsigns 相关映射只在对应 Git Buffer 中启用。

## 格式化策略

- Lua：StyLua，保存时自动格式化。
- JSON / JSONC / YAML：Prettier，保存时自动格式化，使用两空格缩进。
- Markdown：Prettier，**只手动格式化**。
- Python：目前未配置 Conform 格式化工具；Pyright 负责语言服务，不代表已经配置 Python 格式化。
- `.prettierrc.json`、`stylua.toml` 位于此仓库根目录，其他项目可以有自己的格式化规则。

## 插件更新与恢复

### 更新前

先确认 Git 工作区干净，并提交当前可用配置：

```powershell
git status --short
git add -A
git commit -m "chore: snapshot before plugin update"
```

如无变更，Git 会提示没有可提交的内容；无需重复提交。

### 检查和更新插件

在 Neovim 内使用原生 `vim.pack` 更新界面：

```vim
:packupdate
```

阅读更新列表并确认变更。插件更新后检查 `nvim-pack-lock.json` 的 Git 差异；若 `nvim-treesitter` 有更新，再执行：

```vim
:TSUpdate
```

随后重新启动 Neovim 并运行 `:checkhealth` 和常用功能测试。确认无误后，将更新的锁文件和必要的配置提交到 Git。

### 恢复插件锁文件版本

如果更新后发生故障，先恢复对应的 Git 版本（不要直接删除整个 `nvim-data`）。例如，仅撤销**尚未提交**的锁文件变更：

```powershell
git restore -- nvim-pack-lock.json
```

重启 Neovim 后执行：

```vim
:packupdate ++offline ++lockfile
```

检查并确认更新界面，使安装版本与锁文件一致。若问题由已提交的更新引起，应先从已知正常的 Git 提交恢复配置和锁文件，再执行上述同步步骤。Tree-sitter 插件与已编译解析器的版本也必须保持兼容。

## 备份说明

- Git 版本控制适合跟踪配置变更、复现插件修订。
- 额外保留独立的完整配置目录备份，用于误删或本地仓库损坏时恢复。
- 需要跨机器复现时，应同时保留此 README 中的外部依赖和解析器安装步骤。
- 不要把密钥、Token、`.env` 等私密文件提交到公开仓库。
