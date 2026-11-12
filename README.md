# Neovim 配置

使用 Neovim 0.12 原生 `vim.pack` 管理插件、内置 LSP API 配置语言服务的轻量编辑环境。包含文件搜索、代码补全、诊断、格式化、Git 集成与 Markdown 预览，不依赖 Lazy.nvim、Mason 或 nvim-lspconfig。

主要使用环境为 Windows 11、Windows Terminal 和 PowerShell 7；同时提供 Linux 安装指引。Linux 的字体、剪贴板和外部工具需按发行版及桌面会话准备，不代表所有发行版均已完成运行验证。

- 日常功能与快捷键：见本文下方。
- 首次部署、依赖安装及验收：见[安装与环境维护指南](EXTERNAL_DEPENDENCIES.md#deployment)。
- 备份、迁移、更新与故障回退：见[维护流程](EXTERNAL_DEPENDENCIES.md#maintenance)。

## 主要功能

| 类别           | 组件 / 功能                                                                  |
| -------------- | ---------------------------------------------------------------------------- |
| 主题           | Catppuccin Mocha，透明背景                                                   |
| Markdown       | markview.nvim：标题、表格、代码块与 Callout 预览，支持插入模式与 Hybrid 编辑 |
| Buffer 标签栏  | 原生 `tabline`：点击切换、修改标记与长列表省略，无额外插件                   |
| 图标           | mini.icons 与各插件自带图标，使用 Nerd Font                                  |
| 文件搜索与工具 | Snacks.nvim：Picker、Explorer、Dashboard、通知等                             |
| 编辑增强       | Flash、nvim-surround、which-key                                              |
| Git            | Gitsigns、Snacks Git Picker                                                  |
| 补全           | blink.cmp：LSP、Path、Snippets、Buffer；纯 Lua 模糊匹配、幽灵文本与签名帮助  |
| 语法解析       | nvim-treesitter `main` 分支                                                  |
| LSP            | LuaLS、JSON Language Server、YAML Language Server、Pyright                   |
| 格式化         | Conform.nvim：StyLua、Prettier，可选 Ruff / Black 与 shfmt                   |

## 基础依赖

| 范围           | 依赖                                                                                   |
| -------------- | -------------------------------------------------------------------------------------- |
| 启动与插件管理 | Neovim 0.12、Git                                                                       |
| 文件与全文搜索 | ripgrep（`rg`）、fd（部分 Linux 发行版为 `fdfind`）                                    |
| 图标与剪贴板   | Nerd Font 3.x，终端需选用该字体；Linux 按会话配置剪贴板工具                            |
| 语言服务       | LuaLS、JSON Language Server、YAML Language Server、Pyright；npm 工具需要 Node.js / npm |
| 格式化         | StyLua、Prettier；Python 可选 Ruff 或 Black，Shell 可选 shfmt                          |
| 语法解析       | 对应语言的 Tree-sitter 解析器；安装或更新时需要 CLI 0.26.1+、C 编译器、`tar`、`curl`   |

只需安装所用功能对应的工具。当前仅配置 Lua、JSON / JSONC、YAML、Python 的 LSP；JavaScript / TypeScript 等语言的解析器不提供 LSP 功能。blink.cmp 使用纯 Lua 模糊匹配，无须为补全安装 Rust。

插件会由 `vim.pack.add()` 安装，首次安装需要确认。外部程序和解析器没有自动安装逻辑；安装命令、PATH 设置和检查方式统一见[详细依赖清单](EXTERNAL_DEPENDENCIES.md#dependencies)。

## 开始使用

1. 按[首次部署流程](EXTERNAL_DEPENDENCIES.md#deployment)准备环境并放置配置。
2. 完成插件和所需解析器安装、字体选择后，重新启动 `nvim`。
3. 打开项目文件，使用 `<Space>` 查看 which-key 菜单；搜索用 `<Space>ff` / `<Space>fg`，格式化用 `<Space>cf`。

Lua、JSON / JSONC、YAML 保存时会自动格式化；其他已配置语言按下方策略手动格式化。工具缺失时，请参阅[检查与排错](EXTERNAL_DEPENDENCIES.md#verification)。

## 配置结构

```text
nvim/
├── init.lua                  # 加载入口
├── lua/
│   ├── config/               # 基础选项、快捷键、诊断、插件列表与标签栏
│   └── plugins/              # 各插件配置、LSP 与格式化策略
├── nvim-pack-lock.json       # 插件修订锁文件
├── stylua.toml               # 本仓库 Lua 格式规则
├── .prettierrc.json          # 本仓库 Prettier 规则
├── README.md                 # 功能与日常使用
└── EXTERNAL_DEPENDENCIES.md   # 安装、验收、备份、恢复和更新
```

## 常用快捷键

Leader 键为 `<Space>`。

| 快捷键                                  | 功能                                            |
| --------------------------------------- | ----------------------------------------------- |
| `<Space>e`                              | Snacks 文件浏览器                               |
| `<Space>fe`                             | 在文件浏览器中定位当前文件                      |
| `<Space>ff` / `<Space>fg`               | 查找文件 / 全文搜索                             |
| `<Space>fb` / `<Space>fr`               | 查找 Buffer / 最近文件                          |
| `<Space>fc`                             | 编辑 `init.lua`                                 |
| `<Space>cf`                             | 手动格式化当前 Buffer                           |
| `<Space>cd`                             | 查看当前行诊断                                  |
| `gd`                                    | 转到定义（LSP 附加时）                          |
| `grn` / `gra`                           | 原生 LSP 重命名 / Code Action                   |
| `<Space>mt` / `<Space>mT`               | 切换当前 Buffer / 全局 Markdown 预览            |
| `<Space>mh` / `<Space>ml`               | 切换 Hybrid / 行级 Hybrid                       |
| `<Space>ms`                             | 切换 Markdown 分屏预览                          |
| `<Space>gs` / `<Space>gl` / `<Space>gd` | Git 状态 / 日志 / 差异                          |
| `<Space>ws`                             | 保存文件                                        |
| `<Space>wv` / `<Space>wh`               | 垂直 / 水平分屏                                 |
| `<Space>bd`                             | 关闭 Buffer                                     |
| `<Tab>` / `<S-Tab>`                     | 普通模式下切换到下一个 / 上一个 Buffer          |
| `s` / `S`                               | Flash 跳转 / Tree-sitter 选择（适用模式见配置） |
| `]h` / `[h`                             | 下一个 / 上一个 Git 变更块                      |
| `<Space>ga` / `<Space>gr`               | 暂存 / 撤销当前变更块；可视模式支持选区         |
| `<Space>gS` / `<Space>gR`               | 暂存 / 还原整个 Buffer                          |
| `<Space>gp` / `<Space>gD`               | 预览变更块 / 与 Git 索引对比                    |
| `<Space>gb` / `<Space>gB`               | 当前行提交信息 / 切换行内 blame                 |
| `<Space>us` / `<Space>ui`               | 切换平滑滚动 / 缩进参考线                       |
| `<Space>un` / `<Space>ud`               | 通知历史 / 开始页面                             |

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

## 环境维护

安装与维护命令集中在 [EXTERNAL_DEPENDENCIES.md](EXTERNAL_DEPENDENCIES.md)，避免两份文档的步骤不一致：

- [Windows / Linux 首次部署](EXTERNAL_DEPENDENCIES.md#deployment)
- [外部组件安装](EXTERNAL_DEPENDENCIES.md#dependencies)
- [环境检查与排错](EXTERNAL_DEPENDENCIES.md#verification)
- [配置与环境备份](EXTERNAL_DEPENDENCIES.md#backup)
- [迁移与恢复](EXTERNAL_DEPENDENCIES.md#restore)
- [配置、插件与外部工具更新](EXTERNAL_DEPENDENCIES.md#update)
- [更新故障回退](EXTERNAL_DEPENDENCIES.md#rollback)

配置与 `nvim-pack-lock.json` 应一起保留；锁文件不包含外部工具、字体或已编译解析器。
