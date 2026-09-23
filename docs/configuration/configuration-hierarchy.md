# 配置层级与 `config.toml`

> 本文记录 Codex 配置的易变事实。核验日期：2026-09-23；本机 CLI：`codex-cli 0.156.0`。CLI 只读核验命令：`codex --version`、`codex --help`；没有读取本机用户配置或启动模型会话。来源：[Config basics](https://learn.chatgpt.com/docs/config-file/config-basic) [source:OAI-CODEX-CONFIG-BASICS-2026]、[Advanced Configuration](https://learn.chatgpt.com/docs/config-file/config-advanced) [source:OAI-CODEX-CONFIG-ADVANCED-2026]、[Configuration Reference](https://learn.chatgpt.com/docs/config-file/config-reference) [source:OAI-CODEX-CONFIG-REFERENCE-2026]

## 配置从哪里来

Codex 按以下顺序解析配置，同一配置项由顺序更靠前的来源优先：

1. 当前启动命令的 CLI 参数和 `--config` 覆盖。
2. 可信项目中的 `.codex/config.toml`：从项目根目录向当前工作目录逐层加载，同一配置项以最近目录中的值为准。
3. `--profile` 选择的 profile 文件：默认位于 `~/.codex/<名称>.config.toml`；设置 `CODEX_HOME` 后相对该目录解析。
4. 用户级 `~/.codex/config.toml`。
5. 已登录工作区提供的云端托管 `config.toml` 默认值。
6. Unix 系统级 `/etc/codex/config.toml`（如果存在）。
7. Codex 内置默认值。

CLI 与 IDE 扩展共用这些配置层。配置项很多，且版本会变化；编辑前先查当前 [配置参考](https://learn.chatgpt.com/docs/config-file/config-reference)。[source:OAI-CODEX-CONFIG-BASICS-2026]

## 项目配置的信任边界

Codex 只在项目被标记为可信时加载项目 `.codex/` 配置层。项目不可信时，会跳过其中的配置、项目本地 Hooks 和 Rules，但仍加载用户级与系统级配置。相对路径从其所在的 `.codex/` 目录解析。[source:OAI-CODEX-CONFIG-ADVANCED-2026]

项目配置层不能设置一部分机器本地或安全敏感选项，例如 provider/auth 相关配置、`profile`、`notify` 和 `otel`。Codex 会忽略文档列出的受限键，并在启动时警告；这些键应放在用户或系统层，而不是提交到仓库。[source:OAI-CODEX-CONFIG-ADVANCED-2026] [source:OAI-CODEX-CONFIG-REFERENCE-2026]

## 常用位置

```text
$CODEX_HOME/config.toml                   # 用户配置；默认 CODEX_HOME 是 ~/.codex
$CODEX_HOME/<profile>.config.toml         # 由 --profile <profile> 选择
<repo>/.codex/config.toml                 # 可信仓库的项目配置
<repo>/<subdir>/.codex/config.toml        # 更靠近当前目录的项目配置
/etc/codex/config.toml                    # Unix 系统配置（如存在）
```

`CODEX_HOME` 还承载 Codex 本地状态，可能包括认证材料、历史记录、日志和缓存；不要把整个目录提交到仓库，也不要为排查问题直接输出可能含敏感信息的配置或状态文件。[source:OAI-CODEX-CONFIG-ADVANCED-2026]

## 命令行覆盖

本机 `codex --help` 确认当前 CLI 提供 `--profile`、`--config` 和 `--cd` 参数。`--config` 可用点号表示嵌套键，值按 TOML 解析；若不能解析为 TOML，则按字符串处理。以下仅为格式示例，不在本机执行：

```sh
codex --config approval_policy='"on-request"' --cd ./repo
```

`--profile` 是一次启动时选择配置文件的方式，不要把它写入项目级 `.codex/config.toml`；官方文档明确禁止项目层覆盖 profile 选择。[source:OAI-CODEX-CONFIG-ADVANCED-2026] [source:OAI-CODEX-CONFIG-REFERENCE-2026]

## 排查顺序

1. 用 `codex --version` 和 `codex --help` 记录当前 CLI 版本及可用参数。
2. 检查启动命令是否带有专用参数或 `--config` 覆盖；它们的优先级最高。
3. 检查项目是否可信，以及从项目根到当前目录是否存在多个 `.codex/config.toml`。
4. 检查是否通过 `--profile` 选择了另一份 profile 文件，并确认实际 `CODEX_HOME`。
5. 最后再检查用户、组织管理和系统层配置；不要公开粘贴可能包含账户信息的配置内容。

本轮只验证了版本与 CLI 帮助中参数的存在；没有启动模型会话来实测有效配置，因此上面的优先级、信任和路径语义均以官方文档为证，不代表本机运行时已逐层验证。[source:OAI-CODEX-CONFIG-BASICS-2026] [source:OAI-CODEX-CONFIG-ADVANCED-2026]
