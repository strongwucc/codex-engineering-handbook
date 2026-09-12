# Codex 最佳实践知识库第一阶段实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 建立可独立阅读、具备严格来源准入制度并能机械检查基本完整性的 Codex 最佳实践知识库骨架。

**Architecture:** 使用 Markdown 保存导航和维护制度，使用 YAML 登记声明级来源，使用无第三方依赖的 Shell 脚本执行确定性检查。根 `AGENTS.md` 只充当地图和工作协议，不承载正文；易变事实必须通过来源登记和新鲜度状态进入知识库。

**Tech Stack:** Markdown、YAML、POSIX Shell、系统自带 `awk`、`sed`、`find`、`date`、`grep`

**Spec:** `docs/superpowers/specs/2026-09-12-codex-knowledge-base-design.md`

## Global Constraints

- 当前目录是 Codex 知识库唯一事实源。
- ClaudeCode 下的旧 Codex 库是迁移输入，不是持续同步目标。
- 平台事实只能由 OpenAI Docs、OpenAI 官方源码、OpenAI 官方发布说明或 OpenAI 官方系统卡确认。
- 论文用于支持可泛化机制，专家分享用于解释实践经验，不能替代 Codex 当前产品事实。
- 搜索摘要、转载、聚合文章、匿名帖子和营销软文不得进入正式引用。
- 外部事实和技术结论必须具备声明级 `[source:ID]`、适用范围、核验日期和证据等级；来源等级、复核周期和流程门槛等内部治理决策必须标明为本仓库治理决策并说明理由，不伪造外部背书。
- 不安装依赖，不修改锁文件、生产配置或数据库 migration。
- 未经用户明确授权，不执行 `git add`、`git commit`、`git push` 或其他 Git 写操作。
- 每项交付都必须运行本轮新鲜验证；失败或无法运行必须如实标记。

---

## 文件结构

第一阶段创建以下文件：

```text
AGENTS.md
CHANGELOG.md
README.md
docs/maintenance.md
sources/registry.yaml
sources/review-log.md
scripts/verify-knowledge-base.sh
scripts/test-verify-knowledge-base.sh
```

职责边界：

- `README.md`：面向读者的入口、范围、成熟度和导航；
- `AGENTS.md`：面向 Codex 的最小工作协议和渐进式阅读地图；
- `CHANGELOG.md`：记录知识库内容和证据基线的变化；
- `docs/maintenance.md`：完整来源准入、审查、冲突和新鲜度规则；
- `sources/registry.yaml`：机器可读的来源登记；
- `sources/review-log.md`：人工核验记录和被拒来源；
- `scripts/verify-knowledge-base.sh`：正式确定性检查入口；
- `scripts/test-verify-knowledge-base.sh`：在临时目录验证检查器的成功和失败路径。

---

### Task 1: 来源合同与首批官方来源

**Files:**

- Create: `docs/maintenance.md`
- Create: `sources/registry.yaml`
- Create: `sources/review-log.md`

**Interfaces:**

- Consumes: 设计规格中的 S/A/B/X 来源等级、声明级引用格式、新鲜度规则和冲突处理规则。
- Produces: `registry.yaml` 中唯一的 `id`、`level`、`published_at`、`verified_at`、`stability`、`status` 字段；Task 3 的检查器依赖这些字段。

- [x] **Step 1: 写入维护制度**

创建 `docs/maintenance.md`，正文必须包含以下完整章节：

```markdown
# 知识库维护规范

## 来源准入

| 等级 | 允许来源 | 用途 | 禁止替代 |
|---|---|---|---|
| S | OpenAI Docs、OpenAI 官方源码、OpenAI 官方发布说明、OpenAI 官方系统卡 | Codex 产品事实 | 社区转述和搜索摘要 |
| A | 同行评审论文、正式标准、作者原始预印本 | 可泛化机制和评测方法 | 二手论文解读 |
| B | 系统作者、核心维护者、论文作者的原始技术分享 | 实践经验和设计权衡 | Codex 当前配置事实 |
| X | 聚合、转载、营销软文、匿名内容、搜索摘要 | 仅用于发现原始来源 | 任何正式结论 |

## 声明准入

外部事实和技术结论必须使用 `[source:ID]` 引用 `sources/registry.yaml` 中的来源。平台事实至少需要一个 S 级来源；研究结论需要 A 级来源；B 级来源只能补充实践语境。

## 外部声明与内部决策

本规范中的来源等级、复核周期和流程门槛是本仓库治理决策，旨在以可执行的最低标准控制易变平台事实和不可复核转述；它们必须标明为“本仓库治理决策”，不得伪造成外部背书。外部事实和技术结论适用声明级引用要求；内部决策应写明其治理理由，而不要求或伪造 `[source:ID]`。

## 专家来源资格

专家必须与主题有直接贡献关系，内容必须来自本人或主办方原始发布，包含可复核机制、案例或数据，并明确适用边界。必须记录作者与主题的直接关系，解释为什么该作者在此结论上具有权威性；观点与官方事实冲突时，以官方事实为准，并显式记录冲突。知名度本身不构成证据。

## 核验流程

1. 使用搜索工具发现候选原始来源；
2. 实际打开原始页面或论文全文；
3. 记录作者、机构、日期、链接、适用范围和原文支持的声明；
   原文未公开发布日期时，将 `published_at` 显式记录为 `null`，不得用 `verified_at` 替代；
4. 检查更新日期、产品版本、研究样本和实验 Harness；
5. 将来源写入 registry 后再引用；
6. 运行 `scripts/verify-knowledge-base.sh`；
7. 人工审查最终 diff；
8. 只有获得明确授权后才能执行 Git 写操作。

## 冲突与失效

更新的 OpenAI Docs 或官方源码优先于旧的产品说明。论文只在任务、模型、Harness 和指标相近时比较；官方案例与独立研究冲突时并列呈现实验条件，不用权威等级抹平差异。无法消解的冲突标记为 `contested`；已被更新替代的来源标记为 `superseded`；超过复核周期的来源标记为 `review_due`。

## 新鲜度

| 内容 | 复核周期 | 额外触发器 |
|---|---:|---|
| 模型、配置键、默认值、Hook、权限 | 30 天 | Codex 或文档发布变更 |
| 官方工程实践 | 90 天 | 官方文章修订或新案例 |
| 论文结论 | 180 天 | 新版本、复现研究或撤稿 |
| 稳定工程原则 | 365 天 | 评测出现反例 |

超过周期并不自动表示错误，但不能继续无提示地作为当前事实。

## 更新完成条件

- 来源原文已实际打开；
- registry 字段完整且来源 ID 唯一；
- 正文、教程、模板和评测中的受影响内容已同步；
- 确定性检查通过；
- 无法验证的项目被标记为 `blocked`，未冒充通过；
- CHANGELOG 记录了证据基线变化。
```

- [x] **Step 2: 建立首批来源登记**

创建 `sources/registry.yaml`。第一阶段只登记已经实际打开核验的三项官方来源，不提前加入未阅读的论文或专家文章：

```yaml
schema_version: 1
updated_at: '2026-09-12'
sources:
  - id: 'OAI-HARNESS-2026'
    level: 'S'
    publisher: 'OpenAI'
    authors:
      - 'Ryan Lopopolo'
    title: 'Harness engineering: leveraging Codex in an agent-first world'
    published_at: '2026-02-11'
    verified_at: '2026-09-12'
    url: 'https://openai.com/index/harness-engineering/'
    applies_to:
      - 'Codex engineering workflow'
    stability: 'stable'
    status: 'active'
    claims:
      - 'repository knowledge as system of record'
      - 'AGENTS.md as a map rather than a monolithic manual'
      - 'mechanical checks and recurring document maintenance'

  - id: 'OAI-CODEX-BEST-PRACTICES'
    level: 'S'
    publisher: 'OpenAI'
    authors:
      - 'OpenAI'
    title: 'Best practices'
    published_at: null
    verified_at: '2026-09-12'
    url: 'https://learn.chatgpt.com/guides/best-practices'
    applies_to:
      - 'Codex'
      - 'AGENTS.md'
      - 'project configuration'
    stability: 'volatile'
    status: 'active'
    claims:
      - 'keep AGENTS.md short and practical'
      - 'separate user defaults, project configuration, and one-off overrides'

  - id: 'OAI-AGENTS-MD'
    level: 'S'
    publisher: 'OpenAI'
    authors:
      - 'OpenAI'
    title: 'Custom instructions with AGENTS.md'
    published_at: null
    verified_at: '2026-09-12'
    url: 'https://learn.chatgpt.com/docs/agent-configuration/agents-md'
    applies_to:
      - 'Codex AGENTS.md discovery and precedence'
    stability: 'volatile'
    status: 'active'
    claims:
      - 'AGENTS.md discovery and precedence behavior'
```

- [x] **Step 3: 建立人工核验日志**

创建 `sources/review-log.md`：

```markdown
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
```

- [x] **Step 4: 人工核对来源合同**

Run:

```bash
rg -n "^(#|##)|\| [SABX] \|" docs/maintenance.md
rg -n "^  - id:|^    level:|^    published_at:|^    verified_at:|^    stability:|^    status:" sources/registry.yaml
```

Expected:

- 维护文档出现来源准入、声明准入、专家资格、核验流程、冲突、新鲜度和完成条件；
- registry 出现 3 个唯一 ID；
- 每项来源都有 `level`、`published_at`、`verified_at`、`stability` 和 `status`。

- [x] **Step 5: Git 检查点**

只运行：

```bash
git diff -- docs/maintenance.md sources/registry.yaml sources/review-log.md
```

不得运行 `git add` 或 `git commit`。如果当前目录不是 Git 仓库，记录命令原始失败并使用逐文件检查替代。

---

### Task 2: 知识库入口与 Agent 地图

**Files:**

- Create: `README.md`
- Create: `AGENTS.md`
- Create: `CHANGELOG.md`

**Interfaces:**

- Consumes: Task 1 的来源制度和 `sources/registry.yaml`。
- Produces: 人类入口 `README.md`、Codex 入口 `AGENTS.md`、维护历史 `CHANGELOG.md`。

- [x] **Step 1: 创建 README 导航**

`README.md` 必须明确：

```markdown
# Codex 最佳实践知识库

本仓库维护经过来源核验、可执行验证的 Codex Harness 工程实践。平台事实以 OpenAI Docs 或官方源码为准；可泛化机制使用权威论文；专家分享只补充实践语境。

## 当前状态

第一阶段：可信骨架建设中。现有研究笔记和旧 Codex 知识库都是候选输入，不是当前规范。

## 导航

- 设计规格：`docs/superpowers/specs/2026-09-12-codex-knowledge-base-design.md`
- 实施计划：`docs/superpowers/plans/2026-09-12-codex-knowledge-base-phase-1.md`
- 维护与来源准入：`docs/maintenance.md`
- 来源登记：`sources/registry.yaml`
- 来源核验记录：`sources/review-log.md`
- 确定性检查：`scripts/verify-knowledge-base.sh`

## 内容原则

- 不把搜索摘要、聚合文章和无出处社区观点作为证据；
- 不把个人配置或个人偏好包装成通用最佳实践；
- 不把旧模型和旧 CLI 行为包装成当前事实；
- 规范性声明必须可追溯，配置教程必须可验证；
- 验证失败或环境不足必须如实报告。

## 验证

运行：

```bash
scripts/test-verify-knowledge-base.sh
scripts/verify-knowledge-base.sh
```
```

- [x] **Step 2: 创建精简 AGENTS.md**

`AGENTS.md` 控制在 100 行以内，只包含：

```markdown
# Codex 知识库工作协议

## 项目地图

- `README.md`：读者入口和当前状态。
- `docs/maintenance.md`：来源准入、复核和失效规则。
- `docs/configuration/`：经过官方文档和当前 CLI 验证的配置教程。
- `docs/platform/`：模型和版本相关的易变事实。
- `sources/registry.yaml`：正式来源登记。
- `evals/`：评估标准和 holdout。
- `scripts/`：确定性检查。

## 来源规则

- Codex 产品事实只能引用 OpenAI Docs、OpenAI 官方源码、OpenAI 官方发布说明或 OpenAI 官方系统卡。
- 研究结论优先引用同行评审论文或作者原始预印本。
- 专家分享必须来自本人或主办方原始发布，且说明作者与主题的关系。
- 搜索摘要、转载、聚合文章、营销软文和匿名观点不能作为正式证据。
- 先实际打开原始来源，再登记和引用。

## 修改边界

- 精准修改，不顺手重构或改写相邻内容。
- 不整体复制旧知识库；迁移内容必须逐条重新核验。
- 不修改锁文件、生产配置、数据库 migration 或敏感文件。
- 未经明确授权，不执行 Git 写操作。
- 不自主安装或升级依赖。

## 完成标准

- 运行 `scripts/test-verify-knowledge-base.sh`。
- 运行 `scripts/verify-knowledge-base.sh`。
- 审查最终 diff 或逐文件变化。
- 报告本轮真实验证结果；`failed`、`blocked` 和 `not_run` 不得写成通过。
```

- [x] **Step 3: 创建 CHANGELOG**

`CHANGELOG.md` 初始内容：

```markdown
# Changelog

## Unreleased

### Added

- 知识库设计规格和第一阶段实施计划。
- 严格来源准入、声明级引用和新鲜度规则。
- 首批已核验的 OpenAI 官方来源。
- 知识库导航和 Codex 工作协议。
```

- [x] **Step 4: 检查入口的一致性**

Run:

```bash
test "$(wc -l < AGENTS.md | tr -d ' ')" -le 100
for path in docs/maintenance.md sources/registry.yaml sources/review-log.md; do test -f "$path"; done
rg -n "OpenAI Docs|权威论文|专家分享|验证" README.md AGENTS.md
```

Expected: 命令退出码为 0，且所有导航路径存在。

- [x] **Step 5: Git 检查点**

只运行 `git diff -- README.md AGENTS.md CHANGELOG.md`。当前目录不是 Git 仓库时记录失败，不执行 Git 初始化或写操作。

---

### Task 3: 确定性验证器

**Files:**

- Create: `scripts/verify-knowledge-base.sh`
- Create: `scripts/test-verify-knowledge-base.sh`

**Interfaces:**

- Consumes: Task 1 定义的 registry 顶层结构和字段名称。
- Produces: `scripts/verify-knowledge-base.sh [root]`，成功返回 0，失败返回非 0 并输出具体文件或来源 ID；Task 4 和后续所有阶段使用这一入口。

- [x] **Step 1: 先写验证器测试**

测试脚本必须：

1. 使用 `mktemp -d` 创建隔离目录；
2. 用 trap 删除该精确临时目录；
3. 构造一份包含完整来源字段和有效引用的最小知识库，断言验证成功；
4. 删除 `published_at`，断言验证失败，但允许其值为 `null`；
5. 删除 `verified_at`，断言验证失败；
6. 制造重复来源 ID，断言验证失败；
7. 在 Markdown 中引用不存在的 `SRC-MISSING`，断言验证失败；
8. 创建断开的相对 Markdown 链接，断言验证失败；
9. 检查每个失败场景均返回非 0。

Run:

```bash
chmod +x scripts/test-verify-knowledge-base.sh
scripts/test-verify-knowledge-base.sh
```

Expected: FAIL，因为 `scripts/verify-knowledge-base.sh` 尚不存在。

- [x] **Step 2: 实现最小验证器**

`scripts/verify-knowledge-base.sh` 必须采用 `set -eu`，接受可选根目录参数并验证：

```text
required files
  README.md
  AGENTS.md
  docs/maintenance.md
  sources/registry.yaml
  sources/review-log.md

required source fields
  id
  level
  published_at
  verified_at
  url
  stability
  status

allowed enum values
  level: S, A, B
  stability: stable, volatile
  status: active, review_due, contested, superseded
```

实现必须同时检查：

- 来源 ID 唯一；
- Markdown 中形如 `[source:ID]` 的引用在 registry 中存在；
- 相对 Markdown 链接指向已存在文件；
- `AGENTS.md` 不超过 100 行；
- 正式文档不出现未解决占位标记；
- 输出以 `PASS:` 或 `FAIL:` 开头，便于 CI 和 Agent 识别。

不得访问网络、读取工作区外文件或安装 YAML 解析器。首版 YAML 结构固定，允许使用 `awk` 和 `sed` 做窄格式解析；以后结构复杂时再通过独立决策评估解析器。

- [x] **Step 3: 运行测试验证成功与失败路径**

Run:

```bash
chmod +x scripts/verify-knowledge-base.sh
scripts/test-verify-knowledge-base.sh
```

Expected:

```text
PASS: valid fixture accepted
PASS: missing published_at rejected
PASS: missing required field rejected
PASS: duplicate source ID rejected
PASS: unknown source reference rejected
PASS: broken relative link rejected
PASS: verifier test suite
```

- [x] **Step 4: 对真实知识库运行检查**

Run:

```bash
scripts/verify-knowledge-base.sh
```

Expected: `PASS: knowledge base verification`，退出码为 0。

- [x] **Step 5: Git 检查点**

只运行 `git diff -- scripts/verify-knowledge-base.sh scripts/test-verify-knowledge-base.sh`。不得执行任何 Git 写操作。

---

### Task 4: 第一阶段整体验收

**Files:**

- Modify: `CHANGELOG.md`
- Verify: `README.md`
- Verify: `AGENTS.md`
- Verify: `docs/maintenance.md`
- Verify: `sources/registry.yaml`
- Verify: `sources/review-log.md`
- Verify: `scripts/verify-knowledge-base.sh`
- Verify: `scripts/test-verify-knowledge-base.sh`

**Interfaces:**

- Consumes: Task 1～3 的全部交付物。
- Produces: 可独立阅读、来源受控、验证器测试通过的第一阶段知识库骨架。

- [x] **Step 1: 运行全部确定性检查**

Run:

```bash
scripts/test-verify-knowledge-base.sh
scripts/verify-knowledge-base.sh
```

Expected: 两条命令退出码均为 0。

- [x] **Step 2: 检查规范与实现覆盖**

Run:

```bash
for path in README.md AGENTS.md CHANGELOG.md docs/maintenance.md sources/registry.yaml sources/review-log.md scripts/verify-knowledge-base.sh scripts/test-verify-knowledge-base.sh; do test -f "$path" || exit 1; done
rg -n "S \| OpenAI|A \| 同行评审|B \| 系统作者|X \| 聚合" docs/maintenance.md
rg -n "OAI-HARNESS-2026|OAI-CODEX-BEST-PRACTICES|OAI-AGENTS-MD" sources/registry.yaml sources/review-log.md
```

Expected: 所有文件存在，四级来源制度和三个官方来源均可定位。

- [x] **Step 3: 复核外部来源状态**

实际打开而不是只检查 URL 字符串：

- `https://openai.com/index/harness-engineering/`
- `https://learn.chatgpt.com/guides/best-practices`
- `https://learn.chatgpt.com/docs/agent-configuration/agents-md`

Expected: 三个页面均来自 OpenAI 官方域名，且正文支持 registry 中登记的 claims。若页面不可达，标记 `blocked`；若语义变化，停止验收并修正 registry 和正文。

- [x] **Step 4: 更新 CHANGELOG 状态**

在 `Unreleased` 下增加：

```markdown
- 第一阶段确定性验证器及其成功、失败路径测试。
```

- [x] **Step 5: 最终变化审查**

优先运行：

```bash
git status --short
git diff --check
git diff
```

如果目录仍不是 Git 仓库：

```bash
find . -maxdepth 4 -type f -print | sort
scripts/test-verify-knowledge-base.sh
scripts/verify-knowledge-base.sh
```

不得自行执行 `git init`。最终报告必须列出实际执行命令、退出结果、未执行项和限制。

---

## 第一阶段完成门槛

只有全部满足才能标记 `done`：

- 8 个交付文件全部存在；
- `AGENTS.md` 不超过 100 行；
- 三个首批来源均为实际打开核验的官方原始页面；
- `scripts/test-verify-knowledge-base.sh` 真实通过；
- `scripts/verify-knowledge-base.sh` 对真实仓库真实通过；
- 没有将旧知识库转述未经复核地迁入规范层；
- 没有执行未经授权的 Git 写操作；
- 任何环境限制均如实记录，没有把 `blocked` 当成 `passed`。
