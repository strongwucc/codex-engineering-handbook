# AGENTS.md 指令文件

> 本文记录 Codex 配置的易变事实。核验日期：2026-10-21；本机 CLI：`codex-cli 0.163.0`。CLI 仅执行了 `codex --version` 与 `codex --help`，没有启动模型会话验证指令发现行为。来源：[OpenAI 官方文档](https://learn.chatgpt.com/docs/agent-configuration/agents-md) [source:OAI-CODEX-AGENTS-MD-2026]

## 用途与范围

`AGENTS.md` 为 Codex 提供全局或项目级指令。全局规则适合放个人长期偏好；仓库和子目录规则用于说明对应代码范围的约定。Codex 在一次运行或 TUI 会话开始时构建指令链；编辑文件后应启动新会话，再检查新内容是否生效。[source:OAI-CODEX-AGENTS-MD-2026]

## 发现与合并顺序

1. **全局目录**：默认是 `~/.codex`，也可由 `CODEX_HOME` 改变。此层优先读取 `AGENTS.override.md`，否则读取 `AGENTS.md`；仅使用第一个非空文件。
2. **项目目录**：从项目根目录（通常是 Git 根目录）向当前工作目录逐层检查。每层依次尝试 `AGENTS.override.md`、`AGENTS.md`，再尝试配置中的 `project_doc_fallback_filenames`；每个目录最多纳入一个文件。
3. **合并**：项目指令按根目录到当前目录的顺序拼接，目录越近的文件越靠后；较近的说明用于覆盖较宽范围的早先约定。

因此，同一仓库的根目录可以写通用约定，某个子目录再补充该模块特有的规则；需要临时替换同层 `AGENTS.md` 时可用同层 `AGENTS.override.md`。Codex 到达当前工作目录后停止继续向下搜索。[source:OAI-CODEX-AGENTS-MD-2026]

## 最小落地

```text
~/.codex/AGENTS.md                 # 个人默认约定
repo/AGENTS.md                     # 仓库通用约定
repo/services/payments/AGENTS.md   # payments 子目录约定
```

保持每份文件聚焦于其作用范围：根目录写通用规范，子目录只写局部差异。不要把整份团队手册复制进每个目录；超过指令读取限制时，拆分到更近的目录，或检查 `project_doc_max_bytes` 配置。[source:OAI-CODEX-AGENTS-MD-2026]

若仓库使用其他指令文件名，可在 `config.toml` 中配置 `project_doc_fallback_filenames`。Codex 按配置顺序尝试这些名称，但同一目录仍只纳入一个指令文件。[source:OAI-CODEX-AGENTS-MD-2026]

## 验证和排错

- 先用 `codex --help` 确认当前 CLI 接受 `--cd`，再从目标子目录启动新会话，询问 Codex 当前读取了哪些指令文件；这一步会启动真实模型会话，本教程没有替用户执行。
- 指令未加载时，确认启动目录和项目根目录；检查该目录是否有非空的 `AGENTS.override.md`，它会优先于同层 `AGENTS.md`。
- fallback 文件未加载时，确认 `project_doc_fallback_filenames` 的配置拼写，再启动新会话。
- 指令被截断时，检查 `project_doc_max_bytes`，并将规则按目录作用范围拆分。
- 配置文件看起来正确但行为仍旧时，检查 `CODEX_HOME` 是否指向另一套 Codex 主目录。

## 边界

本地 CLI 帮助仅确认了本机版本和 `--cd` 参数；发现与合并规则来自官方文档，未由本轮模型调用作行为验证。不同 CLI 版本可能改变配置键或发现细节；复用本页前应回到上方官方原文重新核对。[source:OAI-CODEX-AGENTS-MD-2026]
