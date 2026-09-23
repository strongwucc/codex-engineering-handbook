# 来源核验日志

## 2026-09-12

### 已接纳

- `OAI-HARNESS-2026`：已打开 OpenAI 原始文章；用于知识库结构和 Harness 工程实践。
- `OAI-CODEX-BEST-PRACTICES`：已打开 OpenAI Docs；用于 Codex 工作流和配置分层；页面未公开发布日期，`published_at` 显式记录为 `null`。
- `OAI-AGENTS-MD`：已打开 OpenAI Docs；用于 AGENTS.md 的发现与覆盖语义；页面未公开发布日期，`published_at` 显式记录为 `null`。

### 已拒绝

- 搜索结果摘要：仅用于定位原始页面，不作为证据登记。
- 营销软文：属于 X 级来源，仅可用于发现原始页面，不作为证据登记。
- 旧知识库中的未复核转述：等待逐条回到原始来源后再决定是否迁移。

## 2026-09-23

### 已接纳

- `A-AGENTBENCH-2024`：已打开 [arXiv 原始记录](https://arxiv.org/abs/2308.03688) 和 [ICLR 2024 论文页](https://proceedings.iclr.cc/paper_files/paper/2024/hash/e9df36b21ff4ee211a8b71ee8b7e9f57-Abstract-Conference.html)。作者机构包括清华大学、俄亥俄州立大学和加州大学伯克利分校。按已发表论文归为 A 级；arXiv 页面显示当前为 v3（2025-10-04 更新），评估结论以 ICLR 2024 论文页为准，只用于交互式、多环境 Agent 评测设计。
- `A-SWE-BENCH-2024`：已打开 [arXiv 原始记录](https://arxiv.org/abs/2310.06770) 和 [ICLR 2024 论文页](https://proceedings.iclr.cc/paper_files/paper/2024/hash/edac78c3e300629acfe6cbe9ca88fb84-Abstract-Conference.html)。作者机构包括 Princeton Language and Intelligence、普林斯顿大学和芝加哥大学。按已发表论文归为 A 级；用于真实仓库 issue 任务和执行环境评测设计，不把论文中的历史模型结果当作当前模型能力结论。
- `A-SWE-BENCH-PLUS-2024`：已打开 [arXiv v2 原始记录](https://arxiv.org/abs/2410.06992)。作者机构为约克大学 Lassonde 工程学院。记录显示 v1 于 2024-10-09 提交、v2 于 2024-10-10 修订；当前登记为作者原始预印本，未按同行评审论文表述。其人工审查结果仅作为特定模型/样本下的数据泄漏与测试质量风险案例，不外推为 SWE-bench 的普遍发生率。
- `B-LANGCHAIN-MULTIAGENT-2025`：已打开 [LangChain 原文](https://www.langchain.com/blog/benchmarking-multi-agent-architectures) 及其链接的 [实验代码仓库](https://github.com/hinthornw/mabench) 和 [LangChain supervisor 实现仓库](https://github.com/langchain-ai/langgraph-supervisor-py)。原文由 LangChain Team 发布并署名 Will Fu-Hinthorn；作者直接报告了自己对多 Agent 架构的实验及实现，符合本仓库 B 级一手工程分享准入。实验基于改造后的 τ-bench、GPT-4o 和 100 条 retail test 样例，结论只作特定设置下的案例，不推广为通用架构排名。
- `OAI-CODEX-AGENTS-MD-2026`：已打开 OpenAI 官方 [AGENTS.md 文档](https://learn.chatgpt.com/docs/agent-configuration/agents-md)，原始 Codex 文档地址重定向至此。页面未公开发布日期，`published_at` 记为 `null`；于 2026-09-23 核验全局/项目发现、逐目录优先级、合并顺序和 fallback 文件配置。当前 CLI `0.156.0` 的 `codex --version` 与 `codex --help` 确认版本和 `--cd` 参数；未启动模型会话，因此文件发现行为仍以官方文档为证，不冒充本地运行验证。
- `OAI-CODEX-CONFIG-BASICS-2026`：已打开 OpenAI 官方 [Config basics](https://learn.chatgpt.com/docs/config-file/config-basic)，于 2026-09-23 核验层级优先级、项目配置受信任状态和 CLI/IDE 共用配置；页面未公开发布日期，记为 `null`。
- `OAI-CODEX-CONFIG-ADVANCED-2026`：已打开 OpenAI 官方 [Advanced Configuration](https://learn.chatgpt.com/docs/config-file/config-advanced)，于 2026-09-23 核验 `CODEX_HOME`、项目 `.codex/config.toml` 加载与路径语义、不可由项目层覆盖的配置项；页面未公开发布日期，记为 `null`。
- `OAI-CODEX-CONFIG-REFERENCE-2026`：已打开 OpenAI 官方 [Configuration Reference](https://learn.chatgpt.com/docs/config-file/config-reference)，于 2026-09-23 核验配置项参考与项目层限制，并用于交叉检查配置层级教程的键名；页面未公开发布日期，记为 `null`。
- `OAI-CODEX-SANDBOXING-2026`：已打开 OpenAI 官方 [Sandbox 文档](https://learn.chatgpt.com/docs/sandboxing)，于 2026-09-23 核验 `read-only`、`workspace-write`、`danger-full-access` 的边界及操作系统差异；页面未公开发布日期，记为 `null`。
- `OAI-CODEX-APPROVALS-SECURITY-2026`：已打开 OpenAI 官方 [Agent approvals & security](https://learn.chatgpt.com/docs/agent-approvals-security)，于 2026-09-23 核验 `on-request`/`never` 与沙箱配置的区别、退休的 `untrusted` 策略和风险较高的无沙箱选项；页面未公开发布日期，记为 `null`。
- `OAI-CODEX-PERMISSIONS-2026`：已打开 OpenAI 官方 [Permissions](https://learn.chatgpt.com/docs/permissions)，于 2026-09-23 核验内置 permission profiles、命令网络规则及其他网络能力的分离边界、各平台执行差异；页面未公开发布日期，记为 `null`。
- `OAI-CODEX-HOOKS-2026`：已打开 OpenAI 官方 [Hooks 文档](https://learn.chatgpt.com/docs/hooks)，于 2026-09-23 核验事件类别、handler 类型、输入/输出、超时与异步限制。页面未公开发布日期，记为 `null`。本机 `codex features list` 在 CLI `0.156.0` 下报告 `hooks stable true`；没有执行 Hook 命令。
- `OAI-CODEX-SKILLS-2026`：已打开 OpenAI 官方 [Build skills 文档](https://learn.chatgpt.com/docs/build-skills)，于 2026-09-23 核验 `SKILL.md` 结构、显式/隐式调用、仓库/用户/管理员发现范围及同名处理；页面未公开发布日期，记为 `null`。本机 `codex --help` 未提供顶层 Skills 命令；未启动会话测试 `$`/`/skills` 调用。
- `OAI-CODEX-SUBAGENTS-2026`：已打开 OpenAI 官方 [Subagents 文档](https://learn.chatgpt.com/docs/agent-configuration/subagents)，于 2026-09-23 核验本地调用方式、自定义 Agent TOML、继承的 sandbox/approval 和并发限制；原文未公开发布日期，记为 `null`。文档提醒并行写密集型任务可能产生冲突，但未承诺子 Agent 使用独立 worktree，因此教程不声称文件系统隔离。本机 CLI `0.156.0` 的 `codex features list` 报告 `multi_agent stable true`；本轮未启动子 Agent。

### 已拒绝

- LangChain 的 [Benchmarking Question/Answering Over CSV Data](https://www.langchain.com/blog/benchmarking-question-answering-over-csv-data)：原文已打开，但主题聚焦表格问答应用，与本阶段的通用 Agent/Harness 评估关联不足；不纳入本轮正式证据。

## 官方发布差异记录

### 2026-09-23 | Codex CLI `0.155.0` → `0.156.0`

- 来源：已打开 OpenAI 官方仓库的 [`0.156.0` 发布说明](https://github.com/openai/codex/releases/tag/rust-v0.156.0) 与 [`0.155.0` 发布说明](https://github.com/openai/codex/releases/tag/rust-v0.155.0)；`0.156.0` 页面列出的完整差异范围为 `rust-v0.155.0...rust-v0.156.0`。[source:OAI-CODEX-CLI-RELEASES-2026]
- 本记录是知识库第一条发布差异记录；比较范围来自官方发布页，不代表已有历史核查记录。当前稳定版本 `0.156.0` 于 2026-09-22 发布，复核日期为 2026-09-23。[source:OAI-CODEX-CLI-RELEASES-2026]
- 相关变化：发布说明包括可选全屏 `/tui`、默认启用语音会话、`/usage` 仪表板、worktree 默认启用、终端主题与 Mermaid/数学公式显示、daemon 管理；还澄清 `friendly`/`pragmatic` personality 设置不再选择响应风格。[source:OAI-CODEX-CLI-RELEASES-2026]
- 影响评估：现有教程未覆盖上述新增交互功能，也未记录 personality 设置，因此不扩写当前配置教程。发布说明称 agent command center 可创建 worktree sessions，但没有说明每个 subagent 都自动拥有独立 worktree；据发布说明范围判断，`docs/configuration/multi-agent.md` 的谨慎表述不需修改。这不是官方对每个 subagent 文件隔离的保证。发布说明还记录了 Windows 入站连接、Linux/macOS 特权 socket 和 macOS 只读文件句柄写入相关的沙箱修复；对照 `OAI-CODEX-SANDBOXING-2026`、`OAI-CODEX-PERMISSIONS-2026` 与 `docs/configuration/permissions-and-sandbox.md`，现有内容只描述平台差异并明确不承诺绝对隔离，没有声称这些旧问题仍存在，故本轮不改教程。[source:OAI-CODEX-CLI-RELEASES-2026] [source:OAI-CODEX-SUBAGENTS-2026] [source:OAI-CODEX-SANDBOXING-2026] [source:OAI-CODEX-PERMISSIONS-2026]
- 处理结果：将官方 releases 页登记为 `OAI-CODEX-CLI-RELEASES-2026`；未自动改写教程或更新其他来源的 `verified_at`。后续 stable release 逐条对比上一条已记录版本；涉及现有声明的差异须先复核其原始来源，再决定同步修改与验证。
