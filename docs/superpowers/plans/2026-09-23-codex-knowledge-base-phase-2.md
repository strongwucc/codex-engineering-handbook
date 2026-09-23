# Codex 知识库第二阶段实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 在严格区分官方事实、学术证据和一手工程经验的前提下，交付可追溯的稳定原则、项目评估标准、H1-H10 holdout 和评估报告模板。

**Architecture:** 先核验并登记实际需要的 A/B 级原始来源，再撰写原则与评估材料；不为凑数设最低来源数量。holdout 任务输入与评估者评分依据分开，评估者依据不挂载到被测 Agent 的工作区。

**Tech Stack:** Markdown、YAML、现有无第三方依赖 Shell 验证脚本。

**Spec:** `docs/superpowers/specs/2026-09-12-codex-knowledge-base-design.md`

## Global Constraints

- 当前目录是 Codex 知识库唯一事实源。
- `codex-best-practices-research.md` 和旧 Codex 知识库只能作为候选材料，不能整体复制。
- Codex 产品事实只能由 OpenAI Docs、OpenAI 官方源码、OpenAI 官方发布说明或 OpenAI 官方系统卡确认。
- A 级来源用于可泛化机制和评测方法；B 级来源只能补充实践语境，不能替代 Codex 当前产品事实。
- 每条外部事实和技术结论必须能追溯到来源登记；仓库治理决策必须明确标为内部决策，不伪造外部背书。
- arXiv 原始预印本不自动代表同行评审成果，必须注明评审状态、版本和适用边界。
- LangChain 等机构发布的文章不因机构名自动成为权威来源；B 级准入须核实作者与主题的直接贡献关系，并确认原文包含可复核机制、案例或数据。
- 不自主安装依赖，不修改锁文件、生产配置或数据库 migration。
- 未经明确授权，不执行 Git 写操作。
- 最终运行 `scripts/test-verify-knowledge-base.sh` 和 `scripts/verify-knowledge-base.sh`，如实报告结果。

## Review Focus

- Codex 当前产品行为误由 A/B 来源推断：评估标准和原则中每项 Codex 产品事实必须能追溯到 S 级来源。
- 预印本的评审状态或版本被误报：来源登记和核验日志须明确区分同行评审论文与预印本。
- 工程文章作者与主题关系不足：B 级来源必须记录作者身份及其直接贡献依据；不满足时拒绝正式引用。
- holdout 评分依据泄露给被测 Agent：只向被测环境提供单项任务输入，不挂载评估者评分文档和其他 holdout。
- 缺失证据或环境失败被记为通过：报告模板分别记录“未发现机械证据”、`blocked`、`not_run` 和实际通过结果。

## 文件结构

- Modify `sources/registry.yaml`：登记本阶段实际采用的来源，保持来源 ID 唯一。
- Modify `sources/review-log.md`：记录原文核验、作者关系、研究版本、适用边界及拒绝理由。
- Create `docs/principles.md`：稳定、跨模型和跨版本的工程原则。
- Create `docs/evaluation-standard.md`：九维度项目评估规则与生产级门槛。
- Create `evals/holdout.md`：仅供评估者使用的 H1-H10 场景清单和评分依据。
- Create `evals/fixtures/H01-precise-change.md` through `evals/fixtures/H10-configuration-compatibility.md`：被测 Agent 单独收到的任务输入，不包含评分答案。
- Create `templates/evaluation-report.md`：一次评估的可复用记录格式。
- Modify `README.md` and `AGENTS.md`：登记新增入口并描述当前阶段。
- Modify `CHANGELOG.md`：记录第二阶段内容与证据基线变化。

---

### Task 1: 核验并登记 A/B 级来源

**Files:**

- Modify: `sources/registry.yaml`
- Modify: `sources/review-log.md`

**Interfaces:**

- Consumes: `docs/maintenance.md` 的来源准入、声明准入和专家来源资格。
- Produces: 可用于稳定原则与评估方法的已核验 A/B 来源；Codex 产品事实仍仅使用 S 级官方来源。

- [x] **Step 1: 建立候选来源清单**

按本阶段原则和评估标准的实际缺口检索原始论文、正式发表版本、作者预印本，以及 LangChain 等系统作者或核心维护者的一手技术文章。检索摘要只用于发现候选，不登记、不引用。不给候选来源设最低数量。

- [x] **Step 2: 打开并逐项核验候选原文**

对每个候选记录作者、机构、发布日期、原始链接、发表或预印本状态、版本、任务与 Harness、样本/指标、支持的具体声明及限制。B 级候选额外核实作者与主题的直接贡献关系；无法核实或原文不支持目标声明的候选予以拒绝。

- [x] **Step 3: 登记通过的来源和声明**

为实际采用的来源分配唯一 ID。registry 仅写入原文已打开且能支持本阶段具体声明的来源；review log 记录核验依据、适用范围和拒绝理由。不得把 A/B 来源用于 Codex 当前配置、权限或 CLI 行为事实。

- [x] **Step 4: 验证来源登记**

Run: `scripts/verify-knowledge-base.sh`

Expected: `PASS: knowledge base verification`。人工确认新来源 ID 唯一，元数据完整，且每条被采纳的声明都能在原文中定位。

### Task 2: 编写稳定工程原则

**Files:**

- Create: `docs/principles.md`
- Consumes: Task 1 核验通过的来源及现有 S 级来源。

**Interfaces:**

- Produces: 每条原则均包含原则、解决的问题、适用条件、不适用条件、支持证据、可执行检查和已知反例或限制。
- 外部事实使用已登记来源 ID；来源不支持的建议须标为本仓库治理决策并解释理由。

- [x] **Step 1: 按设计规格建立文档骨架**

为每条原则创建完整的七项结构；文档开头明确它只收录跨模型、跨版本稳定的内容，并声明不代表 OpenAI 官方评分或规范。

- [x] **Step 2: 从可追溯证据中提炼最小原则集**

只纳入能由已登记 S/A/B 来源支持或明确属于本仓库治理决策的原则。将配置键、默认值、CLI 行为等易变事实排除到第三阶段配置教程。

- [x] **Step 3: 检查证据、边界和内部链接**

Run: `scripts/verify-knowledge-base.sh`

Expected: `PASS: knowledge base verification`；人工逐条确认来源支持对应主张，适用与不适用条件没有被省略。

### Task 3: 编写九维度评估标准

**Files:**

- Create: `docs/evaluation-standard.md`
- Consumes: `docs/principles.md`、Task 1 来源和设计规格。

**Interfaces:**

- Produces: 任务与自主性、上下文、架构约束、熵管理、安全、测试验证、CI/CD、Agent 编排、透明度与可复现性九个维度的统一评分规则。
- 每个维度明确检查对象、项目级/用户全局/当前有效/可移植性四层证据、1/3/5 星锚点、静态扫描边界、生产门槛及 holdout ID。

- [x] **Step 1: 为九个维度写出检查对象和四层证据**

区分仓库文件能直接证明的事实、用户全局配置、当前工作目录下的有效配置，以及换机器/干净环境后的可移植性；不得把缺少机械证据写成通过。

- [x] **Step 2: 写出评分锚点和生产级门槛**

为每个维度给出 1、3、5 星锚点；2、4 星仅可作为相邻锚点之间且有证据支持的中间评分。总体等级不得用算术平均替代门槛判断。安全低于 4 星，或测试验证/CI/CD 任一低于 3 星，不得评为生产级。

- [x] **Step 3: 标出静态扫描边界并关联 holdout**

逐维说明静态证据不能确认的行为，并映射到 H1-H10。环境或权限阻断标为 `blocked`；未检查标为 `not_run`；二者都不算通过。

- [x] **Step 4: 验证文档引用**

Run: `scripts/verify-knowledge-base.sh`

Expected: `PASS: knowledge base verification`；人工逐维核对四层证据、星级锚点、静态边界、生产门槛和 holdout 映射。

### Task 4: 建立 H1-H10 holdout 与隔离任务输入

**Files:**

- Create: `evals/holdout.md`
- Create: `evals/fixtures/H01-precise-change.md`
- Create: `evals/fixtures/H02-read-only-review.md`
- Create: `evals/fixtures/H03-verification-honesty.md`
- Create: `evals/fixtures/H04-sensitive-boundary.md`
- Create: `evals/fixtures/H05-dangerous-command.md`
- Create: `evals/fixtures/H06-instruction-conflict.md`
- Create: `evals/fixtures/H07-skill-trigger.md`
- Create: `evals/fixtures/H08-multi-agent-isolation.md`
- Create: `evals/fixtures/H09-model-upgrade-regression.md`
- Create: `evals/fixtures/H10-configuration-compatibility.md`

**Interfaces:**

- Consumes: `docs/evaluation-standard.md` 的维度与门槛。
- Produces: 每个 fixture 只包含被测 Agent 所需的任务输入；`evals/holdout.md` 保存评估者专用评分依据、任务 ID 和维度映射。

- [x] **Step 1: 建立十项任务的映射和评估者评分依据**

按设计规格固定映射：精准修改、只读审查、验证诚信、敏感信息边界、危险命令、指令冲突、Skill 触发准确性、多 Agent 写入隔离、模型升级回归、配置教程兼容性。每项记录所测维度、可观察成功条件、越界行为和所需验证证据。

- [x] **Step 2: 写隔离的 fixture 任务输入**

每份 fixture 仅包含任务、允许边界和可执行验收条件，不出现评分答案、预期实现细节或其他 holdout 内容。敏感边界案例使用虚构占位数据，不创建或引用真实密钥文件。

- [x] **Step 3: 写评估隔离协议**

规定运行时只把单项 fixture 和必要的被测项目文件提供给 Agent；不挂载 `evals/holdout.md`、其余 fixture 或评分依据。评估者记录测试环境和版本，避免把文档静态检查当作真实配置兼容验证。

- [x] **Step 4: 检查十项完整性与相对链接**

Run: `scripts/verify-knowledge-base.sh`

Expected: `PASS: knowledge base verification`；人工确认 H1-H10 ID 唯一、fixture 与评分映射一一对应、被测输入不含答案、隔离协议可执行。

### Task 5: 添加报告模板并接入导航

**Files:**

- Create: `templates/evaluation-report.md`
- Modify: `README.md`
- Modify: `AGENTS.md`
- Modify: `CHANGELOG.md`

**Interfaces:**

- Consumes: Task 1-4 的来源登记、原则、评分标准和 holdout。
- Produces: 可复用报告模板、可发现的文档入口和阶段变更记录。

- [x] **Step 1: 创建评估报告模板**

模板记录评估日期、目标项目与提交/版本、模型与配置、测试环境、holdout ID、九维度评分及证据、成功数/总数、耗时、Token、审批次数、越界文件数、验证真实性、`passed`/`failed`/`blocked`/`not_run` 状态、生产级结论和限制。所有数量与耗时使用整数；比例使用“成功数/总数”，不使用浮点近似值。

- [x] **Step 2: 更新入口与项目地图**

README 导航到原则、评估标准、holdout 和报告模板，并准确描述阶段状态；AGENTS 地图列出新增正式目录，不承载正文。

- [x] **Step 3: 更新变更记录**

CHANGELOG 记录新增核心原则、评估标准、holdout、模板及来源基线变化；仅在本阶段交付和验证全部完成后标记阶段完成。

- [x] **Step 4: 运行全量确定性验证**

Run:

```bash
scripts/test-verify-knowledge-base.sh
scripts/verify-knowledge-base.sh
```

Expected: 两条命令均返回 0；测试输出各成功/失败场景通过，知识库输出 `PASS: knowledge base verification`。

- [x] **Step 5: 人工检查最终改动**

检查新增文档之间的相对链接、来源 ID、AGENTS 行数限制、报告字段与评估标准的一致性，以及工作区中所有变化。不得把 `git status` 中预先存在的未跟踪内容当作本阶段新增或擅自清理；不执行 Git 写操作。

## 完成门槛

- 每条新增外部主张都能回溯到已打开的原始来源；A/B 来源不被用于证明 Codex 当前产品行为。
- arXiv 预印本和 LangChain 等工程文章分别满足并明确记录对应准入条件。
- 原则、九维度标准、十项 holdout、评估隔离协议和报告模板与设计规格一致。
- 两个知识库验证脚本本轮真实通过；所有被阻断或未执行的验证如实报告。
- README、AGENTS、CHANGELOG 和最终变更清单同步且一致；未执行未经授权的 Git 写操作。
