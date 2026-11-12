# 安装与环境维护指南（Windows / Linux）

本文说明本仓库的首次部署、外部组件安装、环境验收、备份、迁移、更新与故障回退。功能介绍和日常快捷键见 [README](README.md)。命令按当前配置整理；包管理器提供的版本可能变化，安装后应检查版本和实际功能。

## 阅读顺序

- 新环境：[首次部署](#deployment) → [组件安装](#dependencies) → [验收检查](#verification)。
- 已有环境：[备份](#backup) → [更新](#update)；出现问题时按[故障回退](#rollback)处理。
- 换机或重装：[迁移与恢复](#restore)。

Windows 命令使用 PowerShell，Linux 命令使用 Bash。Linux 的发行版命令每组只选一套执行；带 `<版本>`、`<实际文件名>` 等内容为占位符，应替换后执行。以下为操作指引，不会在打开文档或启动 Neovim 时执行。

<a id="deployment"></a>

## 首次部署

1. 安装 Neovim 0.12、Git 和所需的[外部组件](#dependencies)。构建解析器前准备 CLI、C 编译器、下载和解压工具。
2. 如果目标位置已有配置，先按[备份流程](#backup)保存，移开旧目录后再部署，不要将两套配置直接混合。
3. 将仓库克隆到配置目录，或将发布包内容完整复制到该目录。确保目录下直接存在 `init.lua`、`lua/` 和 `nvim-pack-lock.json`，保留隐藏配置文件。
4. 在新终端中启动 `nvim`，阅读并确认插件安装提示。当前 `vim.pack.add()` 保留默认确认行为；应使用随配置发布的锁文件恢复插件修订。
5. 在 Neovim 内安装[语言解析器](#parsers)，等待完成后重启。当前配置不会自动安装缺失解析器。
6. 在终端中选用 Nerd Font，按需准备 Linux 剪贴板，然后完成[验收检查](#verification)。

### 配置和数据路径

| 内容                   | Windows 默认位置           | Linux 默认位置        |
| ---------------------- | -------------------------- | --------------------- |
| 配置                   | `%LOCALAPPDATA%\nvim`      | `~/.config/nvim`      |
| 数据（插件、解析器等） | `%LOCALAPPDATA%\nvim-data` | `~/.local/share/nvim` |
| 状态（撤销历史等）     | 用下方命令查询             | `~/.local/state/nvim` |

设置了 XDG 路径或 `NVIM_APPNAME` 时位置会变化，以 Neovim 实际结果为准：

```vim
:lua for _,k in ipairs({'config','data','state','cache','log'}) do print(k .. ': ' .. vim.fn.stdpath(k)) end
```

以下示例只用于目标目录尚不存在的情况，将仓库地址替换为实际地址：

```powershell
# Windows
git clone <仓库地址> "$env:LOCALAPPDATA\nvim"
```

```bash
# Linux；使用自定义 XDG_CONFIG_HOME 时相应调整
mkdir -p "$HOME/.config"
git clone <仓库地址> "$HOME/.config/nvim"
```

<a id="dependencies"></a>

`lua/config/plugins.lua` 管理的是 Neovim 插件源码。下文的命令行工具、运行环境、字体和 Tree-sitter 语言解析器需要另行安装。按实际使用的语言选择即可，无须安装所有可选组件。

## 1. 组件总览

| 组件 / 命令                                | 用途及配置位置                                        | 必要性                               |
| ------------------------------------------ | ----------------------------------------------------- | ------------------------------------ |
| Neovim 0.12 或更新的兼容版本               | `init.lua`、原生 `vim.pack`、LSP API                  | 基础环境                             |
| Git：`git`                                 | 插件下载、Gitsigns、Snacks Git Picker                 | 基础环境                             |
| ripgrep：`rg`                              | Snacks 全文搜索                                       | 使用全文搜索时需要                   |
| fd：`fd`，部分发行版为 `fdfind`            | Snacks 文件搜索、文件浏览                             | 建议安装；部分文件搜索来源有替代命令 |
| Node.js、npm                               | 运行和安装下列 npm 工具                               | 使用对应工具时需要                   |
| Lua Language Server：`lua-language-server` | `lua/plugins/lsp.lua`：Lua LSP                        | 编辑 Lua 时需要                      |
| `vscode-json-language-server`              | 同上：JSON / JSONC LSP                                | 编辑 JSON / JSONC 时需要             |
| `yaml-language-server`                     | 同上：YAML LSP                                        | 编辑 YAML 时需要                     |
| `pyright-langserver`                       | 同上：Python LSP                                      | 编辑 Python 时需要                   |
| StyLua：`stylua`                           | `lua/plugins/conform.lua`：Lua 保存时格式化           | 使用 Lua 格式化时需要                |
| Prettier：`prettier`                       | JSON / JSONC / YAML 保存时格式化，Markdown 手动格式化 | 使用这些格式化功能时需要             |
| Ruff：`ruff`                               | Python 手动格式化，配置名为 `ruff_format`             | 可选，Python 格式化首选              |
| Black：`black`                             | Ruff 不可用时的 Python 手动格式化                     | 可选，与 Ruff 至少选一个即可         |
| shfmt：`shfmt`                             | Shell（`sh`）手动格式化                               | 可选，不用于 PowerShell              |
| Tree-sitter 语言解析器                     | 高亮、折叠、Flash 结构选择、Markview 预览             | 使用对应功能时需要                   |
| Tree-sitter CLI：`tree-sitter`             | 解析器安装 / 更新                                     | 构建解析器时需要，版本至少 0.26.1    |
| C 编译器、`tar`、`curl`                    | 解析器下载、解压和编译                                | 构建解析器时需要                     |
| Nerd Font                                  | mini.icons、Markdown 和界面图标                       | 当前图标配置建议安装 3.x 字体        |
| 剪贴板工具                                 | `lua/config/options.lua` 的 `clipboard=unnamedplus`   | Linux 按桌面会话补装，见第 7 节      |

当前只配置了 Lua、JSON、YAML、Python 的 LSP。安装 JavaScript / TypeScript 解析器只增加语法解析能力，不会提供这些语言的 LSP。

Python 解释器和项目依赖由项目环境另行管理。Pyright 不包含项目运行环境，也不负责格式化。

## 2. 基础工具和 Node.js

### Windows（PowerShell）

以下命令依赖 Windows 包管理器 `winget`；若没有该命令，可通过 Microsoft Store 安装或更新“应用安装程序”，也可使用各项目官方安装包。

```powershell
winget install --exact --id Neovim.Neovim
winget install --exact --id Git.Git
winget install --exact --id BurntSushi.ripgrep.MSVC
winget install --exact --id sharkdp.fd
winget install --exact --id OpenJS.NodeJS.LTS
```

安装后重新打开终端，检查：

```powershell
nvim --version
git --version
rg --version
fd --version
node --version
npm.cmd --version
```

必须确认 `nvim` 至少为 0.12。若包管理器提供的版本不满足要求，从 [Neovim 官方发布页](https://github.com/neovim/neovim/releases)下载符合要求的 Windows 包，解压并将其中的 `bin` 加入 PATH。不要将“包安装成功”视为版本已经满足。

### Linux

按发行版选择一组命令：

```bash
# Ubuntu / Debian
sudo apt update
sudo apt install git ripgrep fd-find nodejs npm

# Fedora
sudo dnf install git ripgrep fd-find nodejs npm

# Arch Linux
sudo pacman -Syu git ripgrep fd nodejs npm
```

Ubuntu / Debian 的 fd 通常名为 `fdfind`，可以直接验证 `fdfind --version`。若希望统一为 `fd`，在没有同名文件时建立用户级链接：

```bash
mkdir -p "$HOME/.local/bin"
ln -s "$(command -v fdfind)" "$HOME/.local/bin/fd"
```

将 `$HOME/.local/bin` 加入 shell 启动文件的 PATH，例如 Bash 的 `~/.bashrc`：

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Neovim 可先查看发行版提供的版本：Ubuntu / Debian 使用 `apt policy neovim`，Fedora 使用 `dnf info neovim`，Arch 使用 `pacman -Si neovim`。满足 0.12 要求后再使用对应的 `apt install neovim`、`dnf install neovim` 或 `pacman -S neovim`。

若仓库版本过旧，使用 [Neovim 官方安装指南](https://github.com/neovim/neovim/blob/master/INSTALL.md)中的 Linux 预编译包。以下以 x86_64 为例，在下载目录操作；ARM64 必须下载对应架构包：

```bash
# 先从官方发布页下载满足版本要求的 nvim-linux-x86_64.tar.gz
mkdir -p "$HOME/.local/opt"
tar -C "$HOME/.local/opt" -xzf nvim-linux-x86_64.tar.gz
export PATH="$HOME/.local/opt/nvim-linux-x86_64/bin:$PATH"
nvim --version
```

将该 PATH 设置加入所用 shell 的启动文件。Node.js 建议使用仍受支持的 LTS；发行版 Node.js 过旧时，从 [Node.js 官方下载页](https://nodejs.org/en/download)选择相应 Linux 架构包，并按页面指引安装。后续 npm 安装出现 `EBADENGINE` 时应检查运行时版本。

来源：[ripgrep 安装说明](https://github.com/BurntSushi/ripgrep#installation)、[fd 安装说明](https://github.com/sharkdp/fd#installation)。

## 3. 语言服务器（LSP）

### Lua Language Server

Windows：从 [LuaLS 发布页](https://github.com/LuaLS/lua-language-server/releases)下载对应架构的 Windows 压缩包，完整解压到固定目录，例如 `%USERPROFILE%\Tools\lua-language-server`，将其 `bin` 目录加入用户 PATH。保留整个解压目录，不要只复制可执行文件。

Linux：从同一发布页下载匹配 CPU 架构和系统环境的 Linux 包，完整解压。例如在下载目录执行：

```bash
mkdir -p "$HOME/.local/opt/lua-language-server"
# 将下面的包名替换为实际下载的文件名
tar -xzf 'lua-language-server-<版本>-linux-x64.tar.gz' -C "$HOME/.local/opt/lua-language-server"
export PATH="$HOME/.local/opt/lua-language-server/bin:$PATH"
lua-language-server --version
```

将 PATH 写入 shell 启动文件。Windows 同样可用 `lua-language-server --version` 验证。

来源：[LuaLS 安装指南](https://github.com/LuaLS/lua-language-server/wiki/Getting-Started)。

### JSON、YAML、Python LSP

| npm 包名                       | 配置实际调用的命令                    | 文件类型     |
| ------------------------------ | ------------------------------------- | ------------ |
| `vscode-langservers-extracted` | `vscode-json-language-server --stdio` | JSON / JSONC |
| `yaml-language-server`         | `yaml-language-server --stdio`        | YAML         |
| `pyright`                      | `pyright-langserver --stdio`          | Python       |

Windows：

```powershell
npm.cmd install -g vscode-langservers-extracted yaml-language-server pyright
```

这里使用 `npm.cmd`，避免 PowerShell 优先选中 `npm.ps1` 时遇到脚本执行策略问题，无须为此修改全局执行策略。

Linux：先设置用户级 npm 安装目录，避免依赖 `sudo npm install -g`。若使用了 Node 版本管理器并已具备可写全局目录，可跳过这两项 prefix 设置。

```bash
npm config set prefix "$HOME/.local"
export PATH="$HOME/.local/bin:$PATH"
npm install -g vscode-langservers-extracted yaml-language-server pyright
```

验证安装清单使用 `npm.cmd list -g --depth=0`（Windows）或 `npm list -g --depth=0`（Linux）；实际 LSP 功能需打开对应文件后通过 `:checkhealth vim.lsp` 检查。不要把带 `--stdio` 的语言服务当作普通版本查询命令，它们可能一直等待输入。

来源：[JSON 服务](https://github.com/hrsh7th/vscode-langservers-extracted)、[YAML 服务](https://github.com/redhat-developer/yaml-language-server)、[Pyright 安装说明](https://github.com/microsoft/pyright/blob/main/docs/installation.md)。

## 4. 格式化工具

### StyLua（Lua）

Windows：

```powershell
winget install --exact --id JohnnyMorganz.StyLua
stylua --version
```

Linux：从 [StyLua 官方发布页](https://github.com/JohnnyMorganz/StyLua/releases)下载对应架构的 Linux 压缩包，解压后安装可执行文件：

```bash
mkdir -p "$HOME/.local/bin"
# 在已解压出 stylua 的目录中执行
install -m 755 stylua "$HOME/.local/bin/stylua"
stylua --version
```

源码安装是另一选择，已安装 Rust / Cargo 时可执行 `cargo install stylua --locked`；此方式需将 `$HOME/.cargo/bin` 加入 PATH。使用预编译包无需 Rust。

### Prettier（JSON、JSONC、YAML、Markdown）

Windows：

```powershell
npm.cmd install -g prettier
prettier.cmd --version
```

Linux：

```bash
# 使用前文准备好的用户级 npm 目录
npm install -g prettier
prettier --version
```

全局安装便于在不同目录使用；具体项目也可以使用 `npm install --save-dev --save-exact prettier` 固定项目版本。项目级安装只针对该项目，不应视为所有目录都有可用命令。[Prettier 官方安装说明](https://prettier.io/docs/install)

### Ruff / Black（Python，可选）

当前配置优先选择 `ruff`，找不到时才选择 `black`，不是 Ruff 执行报错后重试 Black。Python 仅手动格式化，按 `<Space>cf` 触发。Ruff 在这里仅用于格式化，安装它不会自动启用 Ruff LSP 或额外 lint 功能。

安装 Python 及 pip 后，推荐通过 pipx 安装独立命令行工具。

Windows（先从 [Python 官网](https://www.python.org/downloads/windows/)安装 Python 并确认 `py` 可用）：

```powershell
py -m pip install --user pipx
py -m pipx ensurepath
# 重新打开终端后，按需选择一个
pipx install ruff
# 或：pipx install black
```

Linux：

```bash
# Ubuntu / Debian
sudo apt install python3 python3-pip python3-venv pipx
# Fedora
sudo dnf install python3 python3-pip pipx
# Arch Linux
sudo pacman -S python python-pip python-pipx

pipx ensurepath
# 重新打开终端后，按需选择一个
pipx install ruff
# 或：pipx install black
```

验证所选工具：`ruff --version` 或 `black --version`。若安装在项目虚拟环境中，应从激活该环境的终端启动 Neovim，并通过 `:ConformInfo` 确认当前使用的路径。

来源：[Ruff 安装说明](https://docs.astral.sh/ruff/installation/)、[Black 安装说明](https://black.readthedocs.io/en/stable/getting_started.html)。

### shfmt（Shell，可选）

Windows：从 [shfmt 官方发布页](https://github.com/mvdan/sh/releases)下载匹配架构的 Windows 可执行文件，重命名为 `shfmt.exe`，放到已加入 PATH 的工具目录中。

Linux：

```bash
# Ubuntu / Debian
sudo apt install shfmt
# Fedora
sudo dnf install shfmt
# Arch Linux
sudo pacman -S shfmt
```

若发行版没有该包，从同一发布页下载 Linux 可执行文件，在下载目录执行 `install -m 755 <实际文件名> "$HOME/.local/bin/shfmt"`。

两平台均用 `shfmt --version` 验证；当前只对 `sh` 文件类型配置了手动格式化。

## 5. Tree-sitter 构建环境和解析器

### 构建环境

当前 `main` 分支要求 `tree-sitter` CLI 至少 0.26.1、C 编译器、`tar`、`curl`。CLI 应使用系统包或官方独立发布包，遵循上游不使用 npm 安装 CLI 的要求。[nvim-treesitter 官方要求](https://github.com/nvim-treesitter/nvim-treesitter#quickstart)

Windows：

1. 从 [Tree-sitter CLI 官方发布页](https://github.com/tree-sitter/tree-sitter/releases)下载匹配架构的 Windows 可执行压缩包，解压并重命名为 `tree-sitter.exe`，放入 PATH 中的工具目录。
2. 从 [w64devkit 官方发布页](https://github.com/skeeto/w64devkit/releases)下载匹配架构的开发工具包，解压到固定目录，将其 `bin` 加入 PATH，例如 `%USERPROFILE%\Tools\w64devkit\bin`。
3. Windows 11 通常自带 `tar.exe` 和 `curl.exe`，先验证，无须重复安装。缺失时可从 [bsdtar/libarchive](https://www.libarchive.org/)及 [curl 官方下载页](https://curl.se/windows/)获取对应 Windows 工具并加入 PATH。

```powershell
tree-sitter --version
gcc --version
tar --version
curl.exe --version
```

当前 Windows 配置在 `CC` 未设置且能找到 GCC 时设置 `CC=gcc`，不会下载编译器，也不会覆盖已存在的 `CC`。

Linux：

```bash
# Ubuntu / Debian
sudo apt install build-essential tar curl gzip unzip
# Fedora
sudo dnf install gcc gcc-c++ make tar curl gzip unzip
# Arch Linux
sudo pacman -S base-devel tar curl gzip unzip
```

从 [Tree-sitter CLI 发布页](https://github.com/tree-sitter/tree-sitter/releases)下载适合本机架构的 Linux 包，解压得到可执行文件后：

```bash
mkdir -p "$HOME/.local/bin"
# 将源文件名替换为实际解压后的文件名
install -m 755 tree-sitter-linux-x64 "$HOME/.local/bin/tree-sitter"
tree-sitter --version
cc --version
tar --version
curl --version
```

`gzip` / `unzip` 用于手动解压下载包；它们不是当前 Lua 配置直接调用的工具。安装编译器主要是为了安装或更新解析器，使用已编译解析器时不需要每次重新编译。

<a id="parsers"></a>

### 解析器清单（两平台通用）

| 解析器名称                    | 对应内容                                    |
| ----------------------------- | ------------------------------------------- |
| `lua`                         | Lua                                         |
| `python`                      | Python                                      |
| `bash`                        | Shell，包括 `sh`                            |
| `json`                        | JSON 和 JSONC                               |
| `yaml`                        | YAML                                        |
| `toml`                        | TOML                                        |
| `javascript`                  | JavaScript 和 JSX                           |
| `typescript`                  | TypeScript                                  |
| `tsx`                         | TSX                                         |
| `markdown`、`markdown_inline` | Markview Markdown 基础预览                  |
| `regex`                       | 正则表达式嵌入高亮，按内容使用              |
| `html`、`latex`               | 可选，Markdown 内 HTML / 数学内容的增强解析 |

启动 Neovim，确认插件已安装后，在 Neovim 命令行执行：

```vim
:lua require('nvim-treesitter').install({ 'bash', 'javascript', 'json', 'lua', 'python', 'regex', 'toml', 'typescript', 'tsx', 'yaml', 'markdown', 'markdown_inline' })
```

按需添加：

```vim
:lua require('nvim-treesitter').install({ 'html', 'latex' })
```

安装异步执行，等待结束后重启 Neovim。解析器名称区分大小写。插件更新后执行 `:TSUpdate`，使解析器与插件兼容。不要照搬旧版 `master` 分支的 `configs.setup({ ensure_installed = ... })` 配置。

Markdown 不在本仓库统一高亮回调的白名单中，但 Markview 仍需要 Markdown 解析器。安装 `latex` 解析器不等于安装完整 TeX 发行版；当前基础预览无须额外安装 TeX。[Markview 解析器要求](https://github.com/OXY2DEV/markview.nvim#-requirements)

## 6. 字体

Windows：从 [Nerd Fonts 官方下载页](https://www.nerdfonts.com/font-downloads)选择字体，例如 JetBrainsMono Nerd Font，解压后选中字体文件，右键安装。在 Windows Terminal 的对应配置文件中，将字体改为该 Nerd Font，重新打开终端。

Linux：从同一页面下载字体，解压后将 `.ttf` / `.otf` 文件放到 `~/.local/share/fonts`，随后执行：

```bash
fc-cache -fv
fc-list | rg -i 'nerd'
```

若没有 `fc-cache`，通过发行版包管理器安装 `fontconfig`。在终端设置中选用已安装的字体。只安装字体而未在终端选用，图标仍可能显示异常。

通过 SSH 使用 Neovim 时，通常应在显示终端的本地机器安装、选用字体。

## 7. 系统剪贴板

当前配置使用 `clipboard=unnamedplus`。Windows 通常使用 Neovim 自带的 Windows 剪贴板支持，无须为此安装 `win32yank`。

Linux 根据桌面会话选择一种 provider：

| 会话类型 | 工具                  | Ubuntu / Debian                 | Fedora                          | Arch Linux                    |
| -------- | --------------------- | ------------------------------- | ------------------------------- | ----------------------------- |
| Wayland  | `wl-copy`、`wl-paste` | `sudo apt install wl-clipboard` | `sudo dnf install wl-clipboard` | `sudo pacman -S wl-clipboard` |
| X11      | `xclip`               | `sudo apt install xclip`        | `sudo dnf install xclip`        | `sudo pacman -S xclip`        |

可用 `echo "$XDG_SESSION_TYPE"` 查看会话类型。SSH、容器、WSL 和无桌面服务器的剪贴板还取决于终端与显示环境，不能只靠安装本地桌面工具解决。安装后用 `:checkhealth vim.provider` 检查，再测试 `"+yy` 与 `"+p`。

来源：[Neovim provider 文档](https://github.com/neovim/neovim/blob/master/runtime/doc/provider.txt)。

<a id="verification"></a>

## 8. 安装后的统一检查

### Windows 命令可见性

```powershell
$toolNames = @(
    'nvim', 'git', 'rg', 'fd', 'node', 'npm.cmd',
    'lua-language-server', 'vscode-json-language-server.cmd',
    'yaml-language-server.cmd', 'pyright-langserver.cmd',
    'stylua', 'prettier.cmd', 'tree-sitter', 'gcc', 'tar', 'curl.exe',
    'ruff', 'black', 'shfmt'
)
foreach ($toolName in $toolNames) {
    $found = Get-Command $toolName -ErrorAction SilentlyContinue
    '{0,-35} {1}' -f $toolName, $(if ($found) { $found.Source } else { 'MISSING' })
}
```

### Linux 命令可见性

```bash
for tool in nvim git rg node npm lua-language-server \
  vscode-json-language-server yaml-language-server pyright-langserver \
  stylua prettier tree-sitter cc tar curl ruff black shfmt; do
  command -v "$tool" || printf '%s: MISSING\n' "$tool"
done
command -v fd || command -v fdfind
```

`ruff`、`black`、`shfmt` 缺失是否需要处理，取决于是否使用相应功能；Ruff 与 Black 不必同时存在。命令可见性检查不能代替版本检查和实际运行验证。

### Neovim 检查

从安装工具后的新终端启动 Neovim，再执行：

```vim
:checkhealth vim.pack
:checkhealth nvim-treesitter
:checkhealth vim.lsp
:checkhealth conform
:checkhealth snacks
:checkhealth markview
:checkhealth blink.cmp
:checkhealth which-key
:checkhealth vim.provider
:ConformInfo
```

分别打开 Lua、JSON、YAML、Python、Markdown 和 Shell 文件验证功能。Lua、JSON / JSONC、YAML 保存时会格式化；Markdown、Python、Shell 使用 `<Space>cf` 手动格式化。当前禁止 LSP 格式化兜底，缺失格式化工具时不会自动改用 LSP。

如果终端能找到工具但 Neovim 找不到，使用 `:echo $PATH` 和 `:echo exepath('工具名')` 检查 Neovim 进程实际继承的环境。Windows 的 npm 全局可执行目录通常是 `%APPDATA%\npm`，Linux 按本文设置为 `~/.local/bin`；以 `npm config get prefix` 的结果为准。

## 9. 当前配置无须额外安装的组件

- Rust / Cargo：blink.cmp 使用 `fuzzy.implementation = 'lua'`，无需 Rust 模糊匹配库；仅在自行选择源码构建某些工具时需要 Rust。
- `pynvim`、Node.js Neovim provider、Ruby / Perl provider：当前插件没有要求这些远程 provider；LSP 使用 Node.js 不等于需要安装 `neovim` npm 包。
- `lazygit`：当前 Git 快捷键调用 Snacks Git Picker 与 Gitsigns。
- ImageMagick、图片渲染终端及相关图片工具：当前 `Snacks.image` 未启用。
- LuaSnip、额外 snippets 仓库：当前 blink 配置没有要求这些组件；额外代码片段集合可按以后需求另行添加。

上述清单依据当前功能范围。`nvim-pack-lock.json` 只记录插件修订，不包含外部工具、字体和编译好的解析器；迁移系统时需要重新准备这些组件。

<a id="maintenance"></a>
<a id="backup"></a>

## 10. 配置与环境备份

### 备份范围

| 内容                       | 建议保留的方式                   | 恢复限制                                             |
| -------------------------- | -------------------------------- | ---------------------------------------------------- |
| 配置、隐藏文件、插件锁文件 | Git 提交 + 独立目录副本          | Git 提交不包含未跟踪或被忽略的文件                   |
| 插件、解析器、查询文件     | 可选备份 `stdpath('data')`       | 解析器二进制与操作系统、架构、ABI 相关，跨平台应重建 |
| 撤销历史等状态             | 有需要时备份 `stdpath('state')`  | 关闭 Neovim 后复制，避免使用中的文件不一致           |
| 外部工具                   | 记录版本、来源及安装包           | 插件锁文件不能恢复它们                               |
| 字体、终端设置、PATH       | 记录字体名称、终端配置及环境变量 | 需在目标设备重新安装、设置                           |

缓存通常可以重建，无须作为迁移必需项。数据或状态目录可能包含编辑历史和日志，独立备份应存放在合适的位置，不要直接发布到公开仓库。

### 保存 Git 快照

在配置仓库中检查差异，按文件选择提交：

```bash
git status --short
git diff
# 按需暂存，例如配置和锁文件；文档修改也应按需加入
git add -- init.lua lua nvim-pack-lock.json
git diff --cached
git commit -m "chore: snapshot working configuration"
git rev-parse HEAD
```

上述 Git 命令也适用于 PowerShell。没有变更时不必重复提交。记录最后输出的提交号，以便回退；提交前核对暂存区，不要纳入密钥或本地私密文件。

### 独立复制配置目录

先保存编辑中的文件并关闭 Neovim。以下以默认配置路径为例，备份放在用户主目录；自定义路径应使用前文查询结果替换。

Windows：

```powershell
$configSource = Join-Path $env:LOCALAPPDATA 'nvim'
$backupRoot = Join-Path $env:USERPROFILE ('nvim-backup-' + (Get-Date -Format 'yyyyMMdd-HHmmss'))
New-Item -ItemType Directory -Path $backupRoot -ErrorAction Stop | Out-Null
Copy-Item -LiteralPath $configSource -Destination (Join-Path $backupRoot 'nvim') -Recurse -Force -ErrorAction Stop
Get-ChildItem -LiteralPath (Join-Path $backupRoot 'nvim') -Force
```

Linux：

```bash
config_source="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
backup_root="$HOME/nvim-backup-$(date +%Y%m%d-%H%M%S)"
mkdir "$backup_root" && cp -a "$config_source" "$backup_root/nvim"
ls -la "$backup_root/nvim"
```

复制后确认存在 `init.lua`、`lua/`、`nvim-pack-lock.json` 和隐藏配置；若为 Git 仓库，确认 `.git` 也被保留。不要只复制通配符匹配的可见文件。独立副本应放在配置目录外。

### 记录外部工具版本

保留 `nvim --version`、`git --version`、`tree-sitter --version`、编译器版本，以及已使用格式化工具的版本输出。npm 工具清单可使用：

```powershell
# Windows
npm.cmd list -g --depth=0
```

```bash
# Linux
npm list -g --depth=0
```

使用 pipx 安装 Python 工具时，另保留 `pipx list`。版本清单用于人工复现，不是自动恢复全部组件的锁文件。

<a id="restore"></a>

## 11. 迁移与恢复

### 从仓库或配置副本恢复

1. 保存当前环境的独立备份并关闭 Neovim。
2. 将现有配置目录移到另外的位置，保留为回退副本。只操作通过 `stdpath('config')` 核实过的路径，不要删除整个数据目录。
3. 将已知正常的配置副本完整复制到目标配置路径，或克隆仓库后切换到已知正常的提交。不要多嵌套一层 `nvim`。
4. 按第 2–7 节恢复外部工具、PATH、字体和剪贴板。跨 Windows / Linux 迁移时重新安装工具、编译解析器，避免复制另一平台的可执行文件。
5. 启动 Neovim，确认缺失插件安装。若复用了旧数据目录，按下方步骤将已有插件同步到恢复的锁文件。
6. 安装所需解析器并运行第 8 节验收，确认功能正常后再清理旧副本。

已有插件与锁文件不一致时，在 Neovim 中执行：

```vim
:lua vim.pack.update(nil, { offline = true, target = "lockfile" })
```

检查更新缓冲区，执行 `:write` 确认，或 `:quit` 放弃。`offline=true` 只跳过下载，要求对应 Git 修订已在本地；若提示目标修订不存在，联网后改用：

```vim
:lua vim.pack.update(nil, { target = "lockfile" })
```

同步插件后重启；若 nvim-treesitter 版本变化，执行 `:TSUpdate`，等待完成并再次重启。若启动本身因不兼容插件失败，使用下一节的最小启动恢复方式。

### 恢复数据和状态副本

仅在同平台、同架构且版本兼容时考虑复用完整数据目录。先关闭所有 Neovim 实例，备份并移开现有目标目录，再将数据 / 状态副本复制到实际 `stdpath` 对应位置。Windows 的 data 和 state 可能共享位置，应先核对，避免重复覆盖。

复制完成仍需核对锁文件、解析器和外部工具。恢复配置不等于恢复终端字体、项目虚拟环境或系统 PATH。

<a id="update"></a>

## 12. 配置、插件与外部工具更新

### 更新前

完成第 10 节备份，确保能定位已知正常的配置提交和外部工具版本。升级 Neovim 或插件时先阅读上游兼容要求，尽量分开更新不同层次，以便定位问题。

### 更新配置仓库

在配置仓库中执行：

```bash
git status --short
git fetch
git log --oneline HEAD..@{upstream}
```

PowerShell 中最后一行需写为 `git log --oneline 'HEAD..@{upstream}'`。此流程要求已设置远程仓库和上游分支；发布包用户可改为下载新版本、解压到临时目录后比较。

先提交或独立保存本地修改，工作区干净并确认更新内容后执行 `git pull --ff-only`。如果因分支分叉失败，应先人工处理本地修改，不要用强制重置覆盖。配置更新携带了锁文件变化时，按第 11 节同步插件到该锁文件，而不是直接升级到上游最新版本。

### 更新插件

在 Neovim 中执行：

```vim
:lua vim.pack.update()
```

阅读更新缓冲区，使用 `:write` 确认或 `:quit` 放弃。确认更新后：

1. 检查 `git diff -- nvim-pack-lock.json`。
2. 如果 nvim-treesitter 发生更新，执行 `:TSUpdate`，等待完成。当前配置没有更新后自动执行钩子。
3. 重启 Neovim，执行第 8 节健康检查并验证常用功能。
4. 确认正常后，将锁文件与必要配置修改一起提交到 Git。

### 更新外部工具

外部工具独立于插件锁文件。按原安装方式逐项更新，并重新检查版本：

| 安装来源       | 更新方式                                                                    |
| -------------- | --------------------------------------------------------------------------- |
| Windows winget | `winget upgrade --exact --id <包ID>`，包 ID 见对应安装节                    |
| Linux 系统包   | 使用发行版包管理器更新指定包；Arch 使用 `sudo pacman -Syu` 做完整升级       |
| npm 全局包     | `npm install -g <包名>@<目标版本>`，Windows 使用 `npm.cmd`                  |
| pipx           | `pipx upgrade ruff` 或 `pipx upgrade black`；需固定版本时按目标版本重新安装 |
| 官方发布包     | 下载相同平台 / 架构的目标版本，保留旧目录，再替换工具或切换 PATH            |

例如只更新 Prettier 时使用 `npm.cmd install -g prettier@<目标版本>`（Windows）或 `npm install -g prettier@<目标版本>`（Linux）。项目内的 Prettier 应在项目中更新并提交对应依赖锁文件，不以全局更新替代。

更新 Node.js 等运行环境后，检查 npm 全局目录及工具是否仍可用。解析器构建工具更新后，按需重新构建并检查解析器。

<a id="rollback"></a>

## 13. 更新故障回退

### 只撤销尚未提交的插件锁文件更新

先保存故障现场的配置差异和锁文件副本，确认要放弃的变更后执行：

```bash
git diff -- nvim-pack-lock.json
git restore --source=HEAD --worktree -- nvim-pack-lock.json
```

这只恢复工作区锁文件，不会恢复配置，也不会撤销已暂存或已提交的版本。随后按第 11 节同步到锁文件；仅恢复 JSON 文件不会改变磁盘上已安装的插件。

### 回退已提交的配置或插件更新

先备份本地修改。选择已知正常提交后，在仓库中执行以下命令；它会替换列出的工作区文件，未列出的文件不变：

```bash
git restore --source=<正常提交号> --worktree -- init.lua lua nvim-pack-lock.json
git diff
```

检查差异，并按需恢复该版本涉及的其他配置文件，例如格式规则。若需要整套环境回退，也可以按第 11 节直接恢复完整配置副本。随后同步插件锁文件、重建匹配解析器，验收后将回退结果作为新提交保存。

### 普通启动失败时同步插件

恢复已知正常的配置和锁文件后，从配置目录启动最小 Neovim：

```bash
nvim -u NONE -i NONE
```

在其命令行执行（两平台通用）：

```vim
:lua local specs = {}; local lock = vim.json.decode(table.concat(vim.fn.readfile('nvim-pack-lock.json'), '\n')); for name,p in pairs(lock.plugins) do specs[#specs+1] = { src = p.src, name = name } end; vim.pack.add(specs, { load = false })
:lua vim.pack.update(nil, { offline = true, target = "lockfile" })
```

第一条命令读取当前目录的已恢复锁文件，注册插件而不加载插件脚本；若需要补装缺失插件，仍需联网并确认安装。第二条命令确认后退出，再正常启动。目标 Git 修订不在本地时，按第 11 节移除 `offline=true` 后重试。

### 插件恢复后仍有问题

- 解析器错误：确认 C 编译器及 CLI 可用，在恢复的插件版本下执行 `:TSUpdate`，等待完成后重启。
- LSP / 格式化异常：核对实际命令路径与外部工具版本，按备份记录安装目标版本；插件回退不会自动回退它们。
- 字体、剪贴板异常：检查终端字体和桌面 provider，不必因此重装所有插件。

## 14. 文档与配置自检

在配置目录执行纯 Lua 语法检查，不加载插件（PowerShell / Bash 均可）：

```bash
nvim --headless -u NONE -i NONE -n "+lua for _,f in ipairs(vim.fn.glob('**/*.lua',false,true)) do local fn,e=loadfile(f); assert(fn,e) end; print('Lua syntax OK')" +qa
```

语法通过不代表外部工具或交互功能通过验收，仍需第 8 节检查。

仓库通过 `.gitattributes` 要求 Lua、JSON、TOML 和 Markdown 使用 LF。提交前检查：

```bash
git diff --check
git ls-files --eol
```

`i/lf` 表示索引为 LF，`w/lf` 表示工作区为 LF；`w/crlf` 或 `w/mixed` 需要关注。该检查只覆盖已跟踪文件。在 Neovim 中可用 `:setlocal fileformat?` 查看当前缓冲区格式，但该选项不能完整识别原文件的混合换行。

返回 [README](README.md)。
