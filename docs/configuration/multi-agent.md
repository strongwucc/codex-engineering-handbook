# Multi-Agent 与 Subagents

> 本文记录 Codex 配置的易变事实。核验日期：2026-09-23；本机 CLI：`codex-cli 0.156.0`。已执行只读命令 `codex --version`、`codex features list`、`codex agents --help`；没有启动子 Agent。来源：[OpenAI 官方 Subagents 文档](https://learn.chatgpt.com/docs/agent-configuration/subagents) [source:OAI-CODEX-SUBAGENTS-2026]

## 何时使用

Subagent 是 Codex 为独立子任务派出的专用 Agent；主 Agent 负责拆分任务、收集结果并汇总。当前本地 Codex 支持 subagent 工作流，官方文档称默认启用。你可以直接要求并行分析，也可以在适用的 `AGENTS.md` 或 Skill 中声明何时委派。多个子 Agent 会各自进行模型与工具调用，因此会增加 Token 用量；优先用于可并行、互不依赖的探索、测试分析和资料整理。[source:OAI-CODEX-SUBAGENTS-2026]

交互式 CLI 会话可用 `/agent` 查看或切换 Agent thread。本机 `codex agents --help` 的顶层命令用途是浏览 app-server 上的 Agent sessions；不要把它误认为启动 subagent 的命令。当前本机 `codex features list` 报告 `multi_agent stable true`；该结果只代表 CLI 对本地功能阶段/状态的报告，不等于本轮已实际运行子 Agent。[source:OAI-CODEX-SUBAGENTS-2026]

## 自定义 Agent

本机用户 Agent 放在 `~/.codex/agents/`；仓库级 Agent 放在 `.codex/agents/`。每个 TOML 文件至少包含 `name`、`description` 和 `developer_instructions`。可按需配置模型、推理强度或 `sandbox_mode` 等支持的配置项。[source:OAI-CODEX-SUBAGENTS-2026]

```toml
name = 'docs_auditor'
description = '只读核验技术文档和本仓库对应实现。'
sandbox_mode = 'read-only'
developer_instructions = '''
只读检查资料与实现。
给出来源、证据和适用边界；不要修改文件。
'''
```

文件名可按 Agent 名称命名以便识别，但文档以 `name` 字段为准。全局并发和默认模型等设置放在 `config.toml` 的 `[agents]` 下；`agents.enabled` 默认 `true`，`agents.max_concurrent_threads_per_session` 可限制并发数，未设置时默认值由 Codex 选择，不应自行假定固定数字。现有配置仍可使用旧别名 `agents.max_threads`。[source:OAI-CODEX-SUBAGENTS-2026]

## 权限与执行边界

Subagent 继承父 Agent 当前的 sandbox/permission mode。自定义 Agent 文件可以设置自己的配置默认项，但父会话中的实时权限覆盖会在子 Agent 启动时重新应用。审批请求也可能来自当前不在前台的 Agent thread；批准前先确认请求来源。[source:OAI-CODEX-SUBAGENTS-2026]

**并发写入要谨慎。** OpenAI 文档建议优先并行处理只读任务，并提醒多个 Agent 同时编辑代码可能造成冲突。本页没有承诺每个子 Agent 都运行在独立 worktree，因此不要把 subagent 当作文件系统隔离机制。[source:OAI-CODEX-SUBAGENTS-2026]

本知识库建议：并行任务优先分配只读分析；需要写入时按不重叠文件拆分，或改为串行，并在合并结果后检查完整 diff。此建议是本仓库治理决策，不是 Codex 产品保证。

## 调用示例

```text
请用只读子 Agent 并行检查调用链、测试缺口和安全风险。
等待全部结果后按主题汇总证据和文件位置，不要让多个 Agent 同时修改同一文件。
```

启动后检查各 Agent thread 的进度、批准请求与最终结果；父 Agent 应复核子 Agent 的证据，不把未检查的摘要当作验证结果。[source:OAI-CODEX-SUBAGENTS-2026]

## 验证

1. 执行 `codex --version` 和 `codex features list`，记录安装版本与 `multi_agent` 状态。
2. 使用 `codex agents --help` 区分 session 浏览命令和交互式 `/agent` thread 管理。
3. 如需实测，先在允许启动 Agent 的低风险任务中执行一个只读并行工作流，再检查父线程汇总、Agent thread 和审批/沙箱行为；本轮没有运行此测试，标记为 `not_run`。

本机观察到 `multi_agent stable true`，CLI session 浏览命令可用；并发调度、权限继承和文件写入隔离均未在本轮运行时测试。[source:OAI-CODEX-SUBAGENTS-2026]
