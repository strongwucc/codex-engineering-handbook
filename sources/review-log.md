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

## 2026-10-21

### 定期与发布触发复核

- 范围：登记的 18 项来源中，本轮重新打开并复核 13 项 Codex 产品来源；其中 `OAI-CODEX-BEST-PRACTICES` 与 `OAI-AGENTS-MD` 的旧核验日期为 2026-09-12，已超过 30 天周期。其余配置来源因 CLI 发布变化提前复核。下表所列来源的 `verified_at` 更新为 2026-10-21，状态保持 `active`。

| 来源 ID | 实际打开的原文与复核结论 | 处理 |
|---|---|---|
| [source:OAI-CODEX-BEST-PRACTICES] | [Best practices](https://learn.chatgpt.com/guides/best-practices)：简短实用的 AGENTS.md、个人默认值/项目配置/单次覆盖仍有原文支持。 | `docs/principles.md` 与 `docs/evaluation-standard.md` 的相关声明无需修改。 |
| [source:OAI-AGENTS-MD]、[source:OAI-CODEX-AGENTS-MD-2026] | [Custom instructions with AGENTS.md](https://learn.chatgpt.com/docs/agent-configuration/agents-md)：全局/项目发现、同目录优先级、逐层合并与 fallback 仍有原文支持。 | 同步 `docs/configuration/agents-md.md` 的核验日期与 CLI 观察；原则、评估标准及 holdout 的相关声明不变。 |
| [source:OAI-CODEX-CONFIG-BASICS-2026] | [Config basics](https://learn.chatgpt.com/docs/config-file/config-basic#configuration-precedence)：七级优先级和 CLI/IDE 共用配置仍成立；组织 requirements 另行约束行为。 | `docs/configuration/configuration-hierarchy.md` 补充 CLI 不能解除组织强制约束的边界。 |
| [source:OAI-CODEX-CONFIG-ADVANCED-2026] | [Advanced Configuration](https://learn.chatgpt.com/docs/config-file/config-advanced#project-config-files-codexconfigtoml)：profile 文件、可信项目层、路径、禁止键与 CODEX_HOME 声明仍成立。 | 保留相关教程语义。 |
| [source:OAI-CODEX-CONFIG-REFERENCE-2026] | [Configuration Reference](https://learn.chatgpt.com/docs/config-file/config-reference#configtoml)：项目受限键及权限/审批专门文档入口仍成立。 | 保留相关教程语义。 |
| [source:OAI-CODEX-SANDBOXING-2026] | [Sandbox](https://learn.chatgpt.com/docs/sandboxing)：三种模式及各 OS 实施差异仍有原文支持。 | 同步 `docs/configuration/permissions-and-sandbox.md` 的核验日期与 CLI 观察，不声称已实测隔离。 |
| [source:OAI-CODEX-APPROVALS-SECURITY-2026] | [Agent approvals & security](https://learn.chatgpt.com/docs/agent-approvals-security)：on-request/never、退休 untrusted、自动审批审查与沙箱边界的区别仍成立。 | 保留相关教程语义。 |
| [source:OAI-CODEX-PERMISSIONS-2026] | [Permissions](https://learn.chatgpt.com/docs/permissions)：内置 profiles、命令网络与其他工具控制面分离仍成立。 | 保留相关教程语义。 |
| [source:OAI-CODEX-HOOKS-2026] | [Hooks](https://learn.chatgpt.com/docs/hooks#review-and-trust-hooks)：原有事件、handler、超时和异步声明仍成立；当前文档还要求非托管 Hook 审核并信任其定义，变更后重新审核。 | `docs/configuration/hooks.md` 补充 hash 信任与 `/hooks` 检查步骤；registry 增加对应声明。 |
| [source:OAI-CODEX-SKILLS-2026] | [Build skills](https://learn.chatgpt.com/docs/build-skills)：目录结构、显式/隐式调用、发现范围和同名不合并仍成立。 | 同步 `docs/configuration/skills.md` 的核验日期与 CLI 观察，保留独立 CLI 行为测试未运行的说明。 |
| [source:OAI-CODEX-SUBAGENTS-2026] | [Subagents](https://learn.chatgpt.com/docs/agent-configuration/subagents#approvals-and-sandbox-controls)：当前 CLI 入口为 `/subagents`；自定义 Agent 文件不能覆盖父会话 sandbox/approval，指令中的“只读”不创建只读沙箱。 | 修正 `docs/configuration/multi-agent.md` 的入口、示例与权限说明；registry 增加对应声明。 |
| [source:OAI-CODEX-CLI-RELEASES-2026] | [官方 Releases](https://github.com/openai/codex/releases)：打开稳定版具体发布页并核对版本范围。 | 发布差异单独记录于下方；不据发布说明推断未经测试的隔离保证。 |

以上链接均为本轮实际打开的原始页面；无公开发布日期的 Docs 继续保留 `published_at: null`。AGENTS.md 的两个来源 ID 指向同一原文，本轮同时核对两组声明，不改变现有引用 ID。

本轮未重新核验 `OAI-HARNESS-2026`、三项 `A-*` 论文与 `B-LANGCHAIN-MULTIAGENT-2025`；它们仍在登记周期内，核验日期不变。没有新增来源 ID，也未将未复核来源改成新日期。

### 本地验证范围

- 已运行 `codex --version`、`codex --help`、`codex features list`、`codex sandbox --help`、`codex agents --help`；全部退出 0。本机为 `codex-cli 0.163.0`，报告 `hooks stable true`、`multi_agent stable true`，相应参数仍出现在帮助中。CLI 同时提示受当前环境限制无法创建 PATH aliases；本轮不修改全局环境。
- 本轮资料复核使用只读子 Agent；未启动独立 CLI 模型会话，没有执行 Hook 或沙箱实验。AGENTS.md 发现、配置实际叠加、Hook 信任及执行、Skill 显式/隐式触发、CLI 子 Agent 权限与文件隔离测试均为 `not_run`。
- 模型升级 core/profile 对照、真实项目 holdout 与完整月度审计不在本轮来源维护范围，仍未完成；此次文档复核不作为其通过证据。
- 初轮确定性检查通过，但最终复验暴露既有日期解析缺陷：macOS BSD `date -j -f '%Y-%m-%d'` 会沿用调用时的时分秒，使同一天的来源偶尔被判为未来日期，也可能让超过周期的来源少算一天。直接调用原解析函数复现：2026-10-21 得到 `1792547425`，而 UTC 零点应为 `1792540800`。
- 修复 `scripts/verify-knowledge-base.sh` 的 BSD/GNU 日期入口，显式使用 UTC `00:00:00`，保持周期和来源日期不变；`scripts/test-verify-knowledge-base.sh` 新增真实解析函数的零点归一化断言，以及核验当日允许通过的 fixture。新增断言在修复前按预期失败，修复后完整套件通过；知识库检查、两脚本的 `bash -n` 与 `git diff --check` 均通过。
- 仓库没有独立 lint 或类型检查命令，标记为 `not_run`；本轮除两处日期解析和对应回归测试外，不改应用代码。
- 日期修复与回归套件在本机 macOS 执行；GNU `date` 分支未在 Linux 环境实机验证，标记为 `not_run`。

### 官方发布差异：`0.156.0` → `0.163.0`

复核日期为 2026-10-21；以下七个稳定版的具体原始发布页均已打开，Full Changelog 范围按各页记录。官方发布列表将 `0.163.0` 标为最新稳定版，更高的 `0.164.0` 条目为 alpha；本轮不纳入预发布功能。[source:OAI-CODEX-CLI-RELEASES-2026]

| 发布版本与日期（2026 年） | 官方 Full Changelog 范围 | 与现有声明相关的差异及处理 |
|---|---|---|
| [0.157.0](https://github.com/openai/codex/releases/tag/rust-v0.157.0)，09-25 | `rust-v0.156.0...rust-v0.157.0` | 网络策略覆盖重定向、持续 HTTP/WebSocket 流量及策略撤销；代理路由修复。映射权限教程，保留命令网络与其他工具控制面分离的表述。[source:OAI-CODEX-CLI-RELEASES-2026] |
| [0.158.0](https://github.com/openai/codex/releases/tag/rust-v0.158.0)，09-28 | `rust-v0.157.0...rust-v0.158.0` | 默认审核提权命令的终端输入；修复 Windows 沙箱、Linux 嵌套写根、Git 元数据保护和 macOS 路径别名审批。映射权限教程，现有文档没有承诺这些旧问题仍存在，不增加历史漏洞配置建议。[source:OAI-CODEX-CLI-RELEASES-2026] |
| [0.159.0](https://github.com/openai/codex/releases/tag/rust-v0.159.0)，09-29 | `rust-v0.158.0...rust-v0.159.0` | 已批准命令保留显式文件系统拒绝，写根下默认保护 `.aws`；修复 macOS TLS 沙箱；移除 `tui.prompt_suggestions` 与内置 `plugin-creator`。权限教程补充可写根与显式拒绝的边界；配置与 Skills 教程未引用被移除项，无对应迁移修改。[source:OAI-CODEX-CLI-RELEASES-2026] |
| [0.160.0](https://github.com/openai/codex/releases/tag/rust-v0.160.0)，10-01 | `rust-v0.159.0...rust-v0.160.0` | 策略允许时项目外采用 workspace defaults，恢复保存权限；修复 Windows 沙箱；subagent 保留启动中环境并收到配置或准备失败信息。映射配置、权限和多 Agent 教程，复核当前官方文档后保留已有配置层级，不从发布说明推断运行时加载成功。[source:OAI-CODEX-CLI-RELEASES-2026] |
| [0.161.0](https://github.com/openai/codex/releases/tag/rust-v0.161.0)，10-07 | `rust-v0.160.0...rust-v0.161.0` | 文件系统提权保留拒绝读取与网络限制，后台任务保留来源 turn 权限，重连/新会话保留显式启动权限；凭据说明不再假设总位于 `auth.json`。映射权限与配置教程，保留认证材料“可能包括”的措辞，未写死凭据文件位置。[source:OAI-CODEX-CLI-RELEASES-2026] |
| [0.162.0](https://github.com/openai/codex/releases/tag/rust-v0.162.0)，10-08 | `rust-v0.161.0...rust-v0.162.0` | 启用相应功能时，可信本地项目可创建/列出 managed worktrees；修复 Linux 拒绝文件掩码、沙箱构造程序、ripgrep 配置与 Windows 权限问题。映射权限及多 Agent 教程；worktree 工具的存在不证明每个 subagent 自动隔离，保留该边界。[source:OAI-CODEX-CLI-RELEASES-2026] |
| [0.163.0](https://github.com/openai/codex/releases/tag/rust-v0.163.0)，10-15 | `rust-v0.162.0...rust-v0.163.0` | 恢复权限/网络批准时尊重显式覆盖和当前管理策略；代理在 DNS 查询前检查权限，并修复重复 Host/凭据别名；新增 `/config` 和并行只读工具，澄清 Linux 隔离实现。映射配置与权限教程，补充组织强制约束；界面新增项不扩写为本轮教程主题。[source:OAI-CODEX-CLI-RELEASES-2026] |

影响来源：`OAI-CODEX-CONFIG-BASICS-2026`、`OAI-CODEX-CONFIG-ADVANCED-2026`、`OAI-CODEX-CONFIG-REFERENCE-2026`、`OAI-CODEX-SANDBOXING-2026`、`OAI-CODEX-APPROVALS-SECURITY-2026`、`OAI-CODEX-PERMISSIONS-2026`、`OAI-CODEX-SKILLS-2026`、`OAI-CODEX-SUBAGENTS-2026`；对应原文已按上表复核。上述发布记录不替代实际权限、网络与并发测试。Hooks 定义信任、`/subagents` 及自定义 Agent 权限说明以本轮当前 Docs 为准，本轮未确定其准确引入版本。

覆盖限制：已确认上述七个版本及其连续 changelog 范围，未成功枚举期间的全部稳定补丁列表，完整性核查标记为 `blocked`。网页工具无法访问 GitHub Releases API；本地只读请求及提权重试均因 `api.github.com` DNS 解析失败而退出，未获得列表。不能据此声称稳定补丁全部查齐，也不能把发布说明未提到某项解释为该行为没有变化。
