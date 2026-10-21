# Codex 最佳实践知识库

本仓库沉淀可追溯、可验证的 Codex Harness 工程实践，用于配置开发项目、评估现有项目，并通过实际任务验证规则能否改善正确性、安全性和可维护性。目标与范围见[设计规格](docs/superpowers/specs/2026-09-12-codex-knowledge-base-design.md)。

## 从这里开始

| 你要做什么 | 使用入口 | 预期结果 |
|---|---|---|
| 理解工程原则或查配置 | [稳定原则](docs/principles.md)、[配置教程](#配置教程) | 找到有证据、适用范围和验证方法的说明 |
| 为新项目或已有项目配置 Codex | `configuring-codex-projects` Skill | 项目配置方案，或授权范围内的配置改动 |
| 评估项目的 Codex Harness | `codex-harness-evaluate` Skill、[九维标准](docs/evaluation-standard.md) | 有文件证据的评估、风险和改进建议 |
| 比较模型或 profile 升级 | [模型升级练习集](evals/model-upgrade/README.md) | 同一任务集、隔离环境下的配对结果 |
| 维护来源、处理版本变化 | `maintaining-codex-knowledge-base` Skill、[维护规范](docs/maintenance.md) | 更新声明、教程、来源登记与核验记录 |

## 工具与调用

当前机器有三个直接使用本知识库的 Skills，安装在用户目录 `~/.codex/skills/`，各自入口为 `<Skill 名>/SKILL.md`。它们位于本仓库之外；换机器使用时，需要另行准备对应 Skills，并核对其中的知识库路径。

| Skill | 职责 | 默认边界与输出 |
|---|---|---|
| `configuring-codex-projects` | 按项目情况选择 AGENTS.md、项目设置、共享 Skills、Hooks、自定义 Agent 和权限配置 | 先区分建议与实际修改，说明作用范围、理由和验证方式 |
| `codex-harness-evaluate` | 按当前九维标准收集证据、评估并提出改进建议 | 默认只读；运行项目检查、执行评估任务或写报告需在任务中明确要求 |
| `maintaining-codex-knowledge-base` | 复核来源、处理官方发布差异并同步受影响内容 | 只更新实际核验过的声明与来源，记录未完成项和验证结果 |

向 Codex 提交下面对应的任务即可；将 `/path/to/project` 替换为目标仓库路径。

**配置项目：**

```text
使用 configuring-codex-projects，为 /path/to/project 提供最小 Codex 配置方案，说明个人与项目配置的范围、推荐理由和验证方式。本次只提供建议。
```

**评估项目：**

```text
使用 codex-harness-evaluate，以默认只读模式评估 /path/to/project，按知识库九维标准给出证据、生产门槛和优先改进项。
```

**维护知识库：**

```text
使用 maintaining-codex-knowledge-base，复核到期来源及上次记录之后的官方稳定版变化，同步受影响内容、来源登记和核验日志，运行两项知识库检查；不执行 Git 写操作。
```

## 配套脚本、评测与报告

| 配套项 | 位置 | 用途 |
|---|---|---|
| 证据收集器 | `~/.codex/skills/codex-harness-evaluate/scripts/collect_evidence.py` | 为项目评估收集文件与行号证据、脱敏配置；不自动评分 |
| 收集器回归测试 | 同一 Skill 的 `scripts/test_collect_evidence.py` | 检查证据收集器的行为 |
| 知识库检查器 | [verify-knowledge-base.sh](scripts/verify-knowledge-base.sh) | 检查来源字段、日期、引用 ID 和内部链接等 |
| 检查器回归测试 | [test-verify-knowledge-base.sh](scripts/test-verify-knowledge-base.sh) | 验证检查器的成功、失败及日期边界行为 |
| H01–H10 评估任务 | [evals/fixtures/](evals/fixtures/) | 测试精准修改、只读审查、验证诚信、敏感信息与危险操作边界、指令冲突、Skill 触发、多 Agent 隔离、模型升级和配置兼容性 |
| 模型升级练习集 | [evals/model-upgrade/](evals/model-upgrade/README.md) | 提供独立 Node.js 基线、四项任务、评估者测试与评分表，用于模型/profile 配对比较 |
| 评估报告模板 | [evaluation-report.md](templates/evaluation-report.md) | 统一记录九维证据、任务结果、生产门槛与验证限制 |

仅需收集目标项目证据时，在本知识库根目录执行下例；`--skip-global` 表示只收集项目证据。

```bash
python3 ~/.codex/skills/codex-harness-evaluate/scripts/collect_evidence.py /path/to/project --framework-dir "$PWD" --skip-global
```

执行 H01–H10 时，一次只向被测 Agent 提供一个任务；[holdout 评分依据](evals/holdout.md)仅供评估者使用。模型升级按其 README 的隔离协议执行，验收测试和评分表不得进入被测工作区或上下文。

## 当前状态与验证范围

前三阶段已完成；第四阶段持续维护中。工具文件和评测材料已建立，具体项目的配置效果、评估结论及模型升级效果需要实际运行记录支持。

| 项目 | 已有内容与未完成项 |
|---|---|
| 原则、标准和配置教程 | 已建立；各教程分别记录文档核验、CLI 观察及未运行的行为测试 |
| 来源维护 | 最近一次为 2026-10-21，复核 13 项 Codex 产品来源并同步教程，详见[来源核验日志](sources/review-log.md) |
| 官方发布差异 | 已记录 `0.157.0–0.163.0` 七个稳定版；期间稳定补丁列表的完整性核查因 API 访问受阻标记为 `blocked` |
| 模型升级对照 | 独立练习集已准备，实际 core/profile 对照尚未完成 |
| 完整月度审计 | 尚未完成 |

现有研究笔记和旧 Codex 知识库仍是候选输入，迁入正式内容前须逐条核验原始来源。

## 维护与验证

维护时按[维护规范](docs/maintenance.md)选出到期或受版本变化影响的来源，打开原文逐条核对声明，再同步正文、[来源登记](sources/registry.yaml)、[核验日志](sources/review-log.md)和 [CHANGELOG](CHANGELOG.md)。

在仓库根目录运行：

```bash
scripts/test-verify-knowledge-base.sh
scripts/verify-knowledge-base.sh
git diff --check
```

检查器负责确定性校验；原文是否支持结论、配置是否生效和规则是否改善实际任务，需要分别验证并记录。`failed`、`blocked` 与 `not_run` 如实保留。Git 写操作仍需明确授权。

## 文档导航

### 核心规范

- [稳定工程原则](docs/principles.md)
- [九维度评估标准与生产门槛](docs/evaluation-standard.md)
- [维护与来源准入](docs/maintenance.md)
- [来源登记](sources/registry.yaml)
- [来源核验记录](sources/review-log.md)
- [Codex 工作协议](AGENTS.md)

### 配置教程

- [AGENTS.md 指令文件](docs/configuration/agents-md.md)
- [配置层级与 config.toml](docs/configuration/configuration-hierarchy.md)
- [权限、审批与沙箱](docs/configuration/permissions-and-sandbox.md)
- [Hooks 生命周期钩子](docs/configuration/hooks.md)
- [Skills](docs/configuration/skills.md)
- [Multi-Agent 与 Subagents](docs/configuration/multi-agent.md)

### 设计与实施历史

- [设计规格](docs/superpowers/specs/2026-09-12-codex-knowledge-base-design.md)
- [第一阶段：可信骨架](docs/superpowers/plans/2026-09-12-codex-knowledge-base-phase-1.md)
- [第二阶段：核心内容](docs/superpowers/plans/2026-09-23-codex-knowledge-base-phase-2.md)
- [第三阶段：配置教程](docs/superpowers/plans/2026-09-23-codex-knowledge-base-phase-3.md)
- [第四阶段：新鲜度检查](docs/superpowers/plans/2026-09-23-codex-knowledge-base-phase-4-freshness.md)

## 内容原则

- Codex 产品事实以 OpenAI Docs、官方源码、官方发布说明或系统卡为证据；可泛化研究结论使用原始论文；专家分享只补充实践语境。
- 不把搜索摘要、聚合文章和无出处社区观点作为证据。
- 不把个人配置或个人偏好包装成通用最佳实践。
- 不把旧模型和旧 CLI 行为包装成当前事实。
- 规范性声明必须可追溯，配置教程必须可验证。
- 验证失败或环境不足必须如实报告。
- 评估者评分依据与其他 holdout 不得挂载到被测 Agent 的工作区。
