# Codex 知识库第三阶段实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 逐篇交付六份有 OpenAI 官方来源支撑、并经当前 Codex CLI 核验的配置教程。

**Architecture:** 按主题拆分教程，逐篇打开并核验 OpenAI 官方原文、登记来源，再写清适用范围、配置示例和 CLI 验证证据。最后统一更新导航与阶段状态；不把易变配置事实写入稳定原则。

**Tech Stack:** Markdown、YAML、现有无第三方依赖 Shell 验证脚本、已安装的 Codex CLI。

**Spec:** `docs/superpowers/specs/2026-09-12-codex-knowledge-base-design.md`，第三阶段定义见第 10 节。

## Global Constraints

- 当前仓库是知识库唯一事实源；旧研究笔记只能作为候选材料，不能整体复制。
- Codex 产品事实只能引用已实际打开的 OpenAI Docs、OpenAI 官方源码、官方发布说明或官方系统卡；LangChain、论文和社区文章不得证明当前 Codex 行为。
- 每项外部事实均使用 `sources/registry.yaml` 中的唯一来源 ID；登记作者、标题、日期、核验日期、URL、适用范围、稳定性、状态及支持声明。
- 每篇教程独立核验和交付；当前 CLI 版本与实际执行过的只读验证命令必须如实记录，未能验证的行为标记 `blocked` 或 `not_run`。
- 示例须注明作用域、文件位置及是否覆盖/合并；只写官方文档或本地 CLI 能确认的行为，不推断未说明的优先级或安全保证。
- 不安装依赖，不改锁文件、生产配置、数据库 migration 或敏感文件；不执行 `git add`、`git commit`、`git push` 等 Git 写操作。
- 完成前运行 `scripts/test-verify-knowledge-base.sh`、`scripts/verify-knowledge-base.sh`，并审查最终 diff。

## Review Focus

- 来源是否为 OpenAI 一手原文，页面日期缺失时是否显式记为 `null`；文档改版或重定向时不得沿用未经核验的旧 URL。
- 配置层级、项目目录信任、`AGENTS.md` 发现/优先级、profile 与 `CODEX_HOME` 语义是否有对应的官方声明和当前 CLI 证据。
- sandbox、approval、网络访问、命令执行边界是否被准确区分；不得把某一模式的限制说成绝对安全保证。
- Hooks 与 Skills 的可用性、生命周期、配置格式和稳定状态是否匹配当前官方文档及 CLI；预览/实验特性须标明。
- 多 Agent 教程是否只描述官方支持的 Codex 能力、隔离边界与实际 CLI 行为，不把通用多 Agent 论文或其他框架行为套用到 Codex。
- 相对链接、来源 ID、README/AGENTS 阶段状态、CHANGELOG 与教程中的验证日期是否一致。

## File Structure

- Create `docs/configuration/agents-md.md`：指令文件发现、作用域、优先级与编写边界。
- Create `docs/configuration/configuration-hierarchy.md`：用户/项目/命令行配置、profile 及覆盖关系。
- Create `docs/configuration/permissions-and-sandbox.md`：审批、沙箱模式、命令权限与网络边界。
- Create `docs/configuration/hooks.md`：官方支持的 Hook 配置、触发时机、限制和验证方式。
- Create `docs/configuration/skills.md`：Skill 结构、发现/调用机制、项目与用户作用域。
- Create `docs/configuration/multi-agent.md`：官方多 Agent 能力、启用方式、隔离与限制。
- Modify `sources/registry.yaml`：仅登记教程实际引用且已打开核验的官方来源，来源 ID 保持唯一。
- Modify `sources/review-log.md`：记录逐篇原文核验、支持声明、日期/版本和适用边界。
- Modify `README.md` and check `AGENTS.md`：加入配置教程导航、准确标注第三阶段状态，并确认项目地图已有配置教程目录。
- Modify `CHANGELOG.md`：阶段完成后记录教程和证据基线变化。

---

### Task 1: 编写 `AGENTS.md` 教程

**Files:** Create `docs/configuration/agents-md.md`; modify `sources/registry.yaml` and `sources/review-log.md`.

- [x] 打开当前 OpenAI 官方 `AGENTS.md` 文档，核对原文更新时间/发布日期、发现范围、嵌套覆盖、全局与仓库级指令边界；确认页面确实支持准备写入的每项声明。
- [x] 记录当前 `codex --version`，检查不执行用户任务、不改文件的 CLI 帮助或官方说明，记录实际执行的命令；区分“文档说明”和“CLI 行为已验证”。
- [x] 登记已采用来源，再写教程：解释何时使用、文件放置位置、发现/优先级、最小示例、冲突排查、验证办法和已知限制；易变事实注明核验日期与 CLI 版本。
- [x] 运行 `scripts/verify-knowledge-base.sh`；人工逐项对照原文与引用。

### Task 2: 编写配置层级教程

**Files:** Create `docs/configuration/configuration-hierarchy.md`; modify source registry and review log.

- [x] 打开 OpenAI 官方配置基础与参考文档，核对配置文件路径、项目作用域/信任、命令行覆盖、profile 和 `CODEX_HOME` 的确切规则。
- [x] 用当前 CLI 的只读帮助/诊断入口核验可观察到的配置选项；不读取或输出含凭据的用户配置文件，不把未观测语义写成验证结果。
- [x] 登记实际来源并写独立教程，使用最小 TOML/CLI 示例；逐项标注来源或明确标记为尚未验证。
- [x] 运行 `scripts/verify-knowledge-base.sh`；人工核对优先级声明没有超出官方文档证据。

### Task 3: 编写权限与沙箱教程

**Files:** Create `docs/configuration/permissions-and-sandbox.md`; modify source registry and review log.

- [x] 打开 OpenAI 官方安全、审批和沙箱说明，分别核对各模式的文件系统、网络、审批行为及平台差异。
- [x] 通过当前 CLI 帮助核验模式名称和安全相关参数；不运行破坏性命令、不请求扩大权限、不将帮助输出外推为运行时隔离保证。
- [x] 登记实际来源并写教程，加入威胁边界、选择建议、最小示例和明确的非保证事项。
- [x] 运行 `scripts/verify-knowledge-base.sh`；人工检查安全表述准确、模式区分清楚。

### Task 4: 编写 Hooks 教程

**Files:** Create `docs/configuration/hooks.md`; modify source registry and review log.

- [x] 打开 OpenAI 官方 Hooks 文档及其引用的配置参考，核对支持状态、事件名、输入/输出格式、执行时机、超时/失败语义和适用 CLI 版本。
- [x] 用当前 CLI 只读帮助核验可见入口；如行为无法通过无副作用方式确认，则明确写为仅有文档依据或 `not_run`。
- [x] 登记实际来源并写教程，示例保持最小、可识别，不创建会自动执行任意命令的 Hook。
- [x] 运行 `scripts/verify-knowledge-base.sh`；人工逐项检查生命周期和失败语义来源。

### Task 5: 编写 Skills 教程

**Files:** Create `docs/configuration/skills.md`; modify source registry and review log.

- [x] 打开 OpenAI 官方 Skills 文档，核对目录结构、元数据、发现/调用方式、作用域、工具限制及当前 CLI 支持情况。
- [x] 通过当前 CLI 只读帮助确认公开命令或特性入口；不把第三方 Skill 约定当作 Codex 官方规范。
- [x] 登记实际来源并写教程，包含最小 Skill 结构、放置位置、调用与调试方式及兼容性边界。
- [x] 运行 `scripts/verify-knowledge-base.sh`；人工检查每项结构和机制声明均可追溯。

### Task 6: 编写多 Agent 教程

**Files:** Create `docs/configuration/multi-agent.md`; modify source registry and review log.

- [x] 打开 OpenAI 官方多 Agent 文档和 CLI 帮助，核对启用方式、角色配置、任务委派/等待/恢复机制、并发限制与文件写入隔离语义。
- [x] 使用当前 CLI 只读帮助核验命令/选项；除非已有安全且无副作用的验证路径，不启动子 Agent 或执行并发写入测试。
- [x] 登记实际来源并写教程；将文档事实、CLI 帮助可见项、未实际运行的行为分别标注，说明共享工作区风险和适用限制。
- [x] 运行 `scripts/verify-knowledge-base.sh`；人工确认没有将 LangChain 或学术研究结论写成 Codex 产品行为。

### Task 7: 接入导航与阶段记录

**Files:** Modify `README.md` and `CHANGELOG.md`; check `AGENTS.md`.

- [x] 在 README 为六篇教程建立导航；仅当六篇均通过来源审查及验证后，将当前状态改为第三阶段完成。
- [x] 在 AGENTS 项目地图中列出配置教程目录，不复制教程正文。
- [x] 在 CHANGELOG 记录实际交付内容、官方来源基线变化和验证日期，不提前宣告阶段完成。
- [x] 检查教程与 README/AGENTS 的路径、标题和状态完全一致。

### Task 8: 全量验证与最终审查

- [x] 运行 `scripts/test-verify-knowledge-base.sh`，确认测试输出与退出码。
- [x] 运行 `scripts/verify-knowledge-base.sh`，确认 registry、来源引用与文档结构检查结果。
- [x] 用 `git diff --check` 检查空白错误；审查 `git status --short` 和 `git diff`，确认没有敏感文件或无关变更。
- [x] 按六篇教程逐项复核来源支持、CLI 版本/命令、链接、事实边界和 `blocked`/`not_run` 标记；仅依据本轮输出报告验证状态，不执行 Git 写操作。

## Completion Criteria

- 六篇独立教程均按设计规格完成，每项易变 Codex 产品声明可回溯到已打开的 OpenAI 官方原文。
- 每篇教程记录核验日期、CLI 版本和实际验证命令；文档证据与运行时证据不混淆，无法验证的项目诚实标记。
- 来源 registry 与 review log 一致；README、AGENTS、CHANGELOG 的状态和入口准确。
- 两个项目验收脚本本轮真实通过，最终 diff 经人工审查；没有执行未经授权的 Git 写操作。
