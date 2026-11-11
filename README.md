# Neovim 配置

面向 **Windows 11 + Windows Terminal + PowerShell 7** 的轻量化 Neovim 配置。使用 **Neovim 0.12** 原生 `vim.pack` 管理插件，直接使用内置 LSP API，不依赖 Lazy.nvim、Mason 或 nvim-lspconfig。

## 主要功能

| 类别 | 组件 / 功能 |
| --- | --- |
| 主题 | Catppuccin Mocha，透明背景 |
| Markdown | markview.nvim：标题、表格、代码块与 Callout 预览，支持插入模式与 Hybrid 编辑 |
| Buffer 标签栏 | 原生 `tabline`：点击切换、修改标记与长列表省略，无额外插件 |
| 图标 | mini.icons 与各插件自带图标，使用 Nerd Font |
| 文件搜索与工具 | Snacks.nvim：Picker、Explorer、Dashboard、通知等 |
| 编辑增强 | Flash、nvim-surround、which-key |
| Git | Gitsigns、Snacks Git Picker |
| 补全 | blink.cmp：LSP、Path、Snippets、Buffer；纯 Lua 模糊匹配、幽灵文本与签名帮助 |
| 语法解析 | nvim-treesitter `main` 分支 |
| LSP | LuaLS、JSON Language Server、YAML Language Server、Pyright |
| 格式化 | Conform.nvim：StyLua、Prettier，可选 Ruff / Black 与 shfmt |

## 目录结构

```text
nvim/
├── init.lua
├── lua/
│   ├── config/
│   │   ├── options.lua
│   │   ├── diagnostics.lua
│   │   ├── keymaps.lua
│   │   ├── plugins.lua
│   │   └── tabline.lua
│   └── plugins/
│       ├── blink.lua
│       ├── catppuccin.lua
│       ├── conform.lua
│       ├── flash.lua
│       ├── gitsigns.lua
│       ├── lsp.lua
│       ├── markview.lua
│       ├── mini-icons.lua
│       ├── snacks.lua
│       ├── surround.lua
│       ├── treesitter.lua
│       └── which-key.lua
├── nvim-pack-lock.json
├── stylua.toml
├── .prettierrc.json
├── .gitattributes
└── .gitignore
```

## 环境要求

### 基础工具

- **Neovim 0.12**（该配置使用 `vim.pack` 和 Neovim 内置 LSP 配置 API）。
- Git（插件克隆及版本管理）。
- ripgrep (`rg`) 与 fd (`fd`)（Snacks Picker 文件搜索和全文搜索）。
- Nerd Font 3.0.0 或更新版本，用于 mini.icons、Markdown 和界面图标；需在终端中选用对应字体。

### LSP 与格式化工具

| 命令 | 用途 | 安装来源示例 |
| --- | --- | --- |
| `lua-language-server` | Lua LSP | Lua Language Server |
| `vscode-json-language-server` | JSON / JSONC LSP | npm 包 `vscode-langservers-extracted` |
| `yaml-language-server` | YAML LSP | npm 包 `yaml-language-server` |
| `pyright-langserver` | Python LSP | npm 包 `pyright` |
| `stylua` | Lua 格式化 | StyLua |
| `prettier` | JSON / JSONC / YAML / Markdown 格式化 | npm 包 `prettier` |
| `ruff` | Python 手动格式化，优先使用（可选） | Ruff |
| `black` | Ruff 不可用时的 Python 手动格式化工具（可选） | Black |
| `shfmt` | Shell 手动格式化（可选） | shfmt |

已经安装 Node.js/npm 的环境，可安装以下 npm 工具：

```powershell
npm install -g vscode-langservers-extracted yaml-language-server pyright prettier
```

Lua Language Server 和 StyLua 需要单独安装，并确保对应命令可以在 `PATH` 中找到。

### Tree-sitter 解析器编译

当前锁定的 nvim-treesitter 要求 `tree-sitter` CLI 0.26.1 或更新版本、`tar`、`curl` 和 C 编译器。CLI 应使用独立发布包或系统包管理器安装，遵循该插件不使用 npm 安装 CLI 的要求。当前 Windows 环境使用 **w64devkit GCC**。需要编译解析器时，请确保 `gcc` 在 `PATH` 中；`treesitter.lua` 只在适合的 Windows 环境下设置 `CC=gcc`，不会覆盖已经存在的 `CC`。

在 PowerShell 中检查外部工具：

```powershell
$commands = @(
    'nvim', 'git', 'rg', 'fd',
    'lua-language-server',
    'vscode-json-language-server',
    'yaml-language-server',
    'pyright-langserver',
    'stylua', 'prettier', 'ruff', 'black', 'shfmt',
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
3. 启动 Neovim。`vim.pack.add()` 会尝试安装缺失的插件；`nvim-pack-lock.json` 应与配置一起保留，以恢复相应修订。首次安装会弹出待安装插件确认框（vim.pack.add 的 confirm 默认 true）。
4. 安装 Tree-sitter 解析器。在 Neovim 内执行：

   ```vim
   :lua require('nvim-treesitter').install({ 'bash', 'javascript', 'json', 'lua', 'python', 'regex', 'toml', 'typescript', 'tsx', 'yaml', 'markdown', 'markdown_inline' })
   ```

   安装异步进行，等待完成后再重启。解析器名称区分大小写，使用小写 `markdown` 和 `markdown_inline`。JSONC 使用 `json`，Shell 使用 `bash`，TSX 使用 `tsx`。

5. 安装完成后重新启动 Neovim，依次检查：

   ```vim
   :checkhealth vim.pack
   :checkhealth nvim-treesitter
   :checkhealth vim.lsp
   :checkhealth blink.cmp
   :checkhealth conform
   :checkhealth snacks
   :checkhealth markview
   :checkhealth which-key
   ```

6. 打开 Lua、Python、JSON、YAML、Markdown 文件，验证 LSP、补全、格式化和 Markdown 预览。`Snacks.image` 与 `lazygit` 的可选依赖提示不代表当前启用功能异常。

> 注意：Git 仓库包含配置和插件锁文件，**不包含** `nvim-data` 中已安装的插件、编译后的解析器、系统字体及外部 LSP/格式化程序。它们需要在目标设备上重新安装。

## 常用快捷键

Leader 键为 `<Space>`。

| 快捷键 | 功能 |
| --- | --- |
| `<Space>e` | Snacks 文件浏览器 |
| `<Space>fe` | 在文件浏览器中定位当前文件 |
| `<Space>ff` / `<Space>fg` | 查找文件 / 全文搜索 |
| `<Space>fb` / `<Space>fr` | 查找 Buffer / 最近文件 |
| `<Space>fc` | 编辑 `init.lua` |
| `<Space>cf` | 手动格式化当前 Buffer |
| `<Space>cd` | 查看当前行诊断 |
| `gd` | 转到定义（LSP 附加时） |
| `grn` / `gra` | 原生 LSP 重命名 / Code Action |
| `<Space>mt` / `<Space>mT` | 切换当前 Buffer / 全局 Markdown 预览 |
| `<Space>mh` / `<Space>ml` | 切换 Hybrid / 行级 Hybrid |
| `<Space>ms` | 切换 Markdown 分屏预览 |
| `<Space>gs` / `<Space>gl` / `<Space>gd` | Git 状态 / 日志 / 差异 |
| `<Space>ws` | 保存文件 |
| `<Space>wv` / `<Space>wh` | 垂直 / 水平分屏 |
| `<Space>bd` | 关闭 Buffer |
| `<Tab>` / `<S-Tab>` | 普通模式下切换到下一个 / 上一个 Buffer |
| `s` / `S` | Flash 跳转 / Tree-sitter 选择（适用模式见配置） |
| `]h` / `[h` | 下一个 / 上一个 Git 变更块 |
| `<Space>ga` / `<Space>gr` | 暂存 / 撤销当前变更块；可视模式支持选区 |
| `<Space>gS` / `<Space>gR` | 暂存 / 还原整个 Buffer |
| `<Space>gp` / `<Space>gD` | 预览变更块 / 与 Git 索引对比 |
| `<Space>gb` / `<Space>gB` | 当前行提交信息 / 切换行内 blame |
| `<Space>us` / `<Space>ui` | 切换平滑滚动 / 缩进参考线 |
| `<Space>un` / `<Space>ud` | 通知历史 / 开始页面 |

完整快捷键可通过 which-key 菜单查看；Gitsigns 相关映射只在对应 Git Buffer 中启用。

## Buffer 标签栏与 Markdown 编辑

- 顶部标签栏由 `lua/config/tabline.lua` 使用原生接口实现，显示已列出的普通和终端 Buffer。标签包含 Buffer 编号，同名文件可据此区分。
- 左键点击标签切换 Buffer；`+` 表示未保存修改。标签过多时显示当前 Buffer 附近的标签，两侧 `‹` / `›` 表示还有其他 Buffer。
- `<Space>bd` 调用 `Snacks.bufdelete()`，关闭 Buffer 时尽量保留分屏布局。
- 标签栏显示 Buffer，不显示原生 tabpage 列表；tabpage 仍可使用 `gt` / `gT` 切换。当前没有标签拖动排序、固定或关闭按钮。
- Markdown 使用两空格缩进，关闭自动折行，`conceallevel=2`。插入模式仍保留预览，Hybrid 会将正在编辑范围内的节点还原为源码。
- 超过 500 行的 Markdown 使用局部渲染；当前 debounce 为 150ms。性能取决于内容复杂度与机器环境。
- 当前未开启 Snacks 的大文件保护和终端图片渲染。

## 格式化策略

- Lua：StyLua，保存时自动格式化。
- JSON / JSONC / YAML：Prettier，保存时自动格式化，使用两空格缩进。
- Markdown：Prettier，**只手动格式化**。
- Python：只手动格式化，优先使用 `ruff_format`（外部命令 `ruff`），不可用时选用 `black`；只运行首个可用工具，不是执行失败后自动重试。需自行安装所选工具，Pyright 不负责格式化。
- Shell（`sh`）：使用 `shfmt`，只手动格式化，需自行安装工具。
- 手动格式化使用 `<Space>cf`。保存时格式化为同步操作，超时上限 3000ms；手动调用使用 Conform 默认超时。当前禁止 LSP 格式化兜底。
- `.prettierrc.json`、`stylua.toml` 位于此仓库根目录，其他项目可以有自己的格式化规则。

## 插件更新与恢复

### 更新前

先检查工作区差异，再按需暂存并提交当前可用配置：

```powershell
git status --short
git diff
# 检查后按文件暂存，例如：git add -- README.md
# 暂存完成后检查：git diff --cached
git commit -m "chore: snapshot before plugin update"
```

如无变更，Git 会提示没有可提交的内容；无需重复提交。

### 检查和更新插件

在 Neovim 内使用原生 `vim.pack` 更新界面：

```vim
:lua vim.pack.update()
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
:lua vim.pack.update(nil, { offline = true, target = "lockfile" })
```

检查并确认更新界面，使安装版本与锁文件一致。若问题由已提交的更新引起，应先从已知正常的 Git 提交恢复配置和锁文件，再执行上述同步步骤。Tree-sitter 插件与已编译解析器的版本也必须保持兼容。

## 配置自检与换行符

在配置目录的 PowerShell 中执行纯 Lua 语法检查；此命令不加载插件：

```powershell
nvim --headless -u NONE -i NONE -n "+lua for _,f in ipairs(vim.fn.glob('**/*.lua',false,true)) do local fn,e=loadfile(f); assert(fn,e) end; print('Lua syntax OK')" +qa
```

语法检查不代表 LSP、外部工具和交互功能已通过验收，仍需正常启动并执行前面的健康检查。

仓库通过 `.gitattributes` 要求配置与文档使用 LF，StyLua、Prettier 也输出 LF。查看已跟踪文件的换行符：

```powershell
git ls-files --eol
git ls-files --eol | Select-String 'w/(crlf|mixed)'
```

`i/lf` 表示索引为 LF，`w/lf` 表示工作区为 LF；`w/crlf` 表示工作区为 CRLF，`w/mixed` 表示混合换行。第二条命令没有输出，表示已跟踪文件中未检测到工作区 CRLF 或混合换行；未跟踪文件不在检查范围内。

在 Neovim 中可用 `:setlocal fileformat?` 查看当前 Buffer 的换行格式：`unix` 为 LF，`dos` 为 CRLF。该选项不能完整判断原文件是否混合换行。

## 备份说明

- Git 版本控制适合跟踪配置变更、复现插件修订。
- 额外保留独立的完整配置目录备份，用于误删或本地仓库损坏时恢复。
- 需要跨机器复现时，应同时保留此 README 中的外部依赖和解析器安装步骤。
- 不要把密钥、Token、`.env` 等私密文件提交到公开仓库。
