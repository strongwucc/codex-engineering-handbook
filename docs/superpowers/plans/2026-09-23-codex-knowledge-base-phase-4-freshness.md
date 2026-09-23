# 第四阶段：来源新鲜度检查实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 让知识库验证器按来源登记的复核周期识别过期的 active 来源，并报告问题但不自动修改来源状态。

**Architecture:** 在 registry 中为每个来源显式登记 `review_interval_days`，避免根据来源等级或 `stability` 猜测复核周期。验证器依据 `verified_at` 与该周期检查 active 来源；过期时报告并失败，任何状态变更仍由人工审阅原始来源后完成。

**Tech Stack:** Bash、awk、BSD/GNU `date`、现有知识库 shell 验证脚本。

**Spec:** `docs/superpowers/specs/2026-09-12-codex-knowledge-base-design.md` 第 9、10 节；周期政策见 `docs/maintenance.md`。

## Global Constraints

- 复核周期只能取维护规范定义的 30、90、180 或 365 天，按来源支持的内容类别选择，不从来源等级或 `stability` 推导。
- 到期检查只读；不自动改写 `status`、`verified_at` 或其他 registry 内容。
- `verified_at` 必须是有效的 `YYYY-MM-DD` 日期；未来日期和无效日期均报告为错误。
- 周期已超过才算过期；恰好达到周期天数时仍通过。
- 测试使用固定的 `KNOWLEDGE_BASE_TODAY` 日期覆盖值；正常运行默认使用 UTC 当前日期。
- 不安装依赖，不改锁文件、生产配置、数据库 migration 或敏感文件；不执行 Git 写操作。
- 最终运行两个知识库验收脚本、检查 `git diff --check`，并人工审查完整 diff。

## Review Focus

- 缺少或不支持的 `review_interval_days` 必须失败，不能悄悄跳过来源。
- 日期解析须兼容 macOS BSD `date` 与 GNU `date`，并拒绝格式正确但不存在的日历日期。
- 过期 active 来源须明确报告来源 ID、核验日期和周期，退出非零；不能自动把状态改成 `review_due`。
- 到期边界使用严格大于；恰好等于周期的来源不应被提前判过期。
- `superseded`、`contested` 和 `review_due` 是人工管理状态；本检查不擅自重分类这些来源。

## File Structure

- Modify `scripts/verify-knowledge-base.sh`：解析周期字段、验证日期和周期，并输出过期 active 来源错误。
- Modify `scripts/test-verify-knowledge-base.sh`：增加固定日期的到期、边界、非法元数据及无副作用回归测试。
- Modify `sources/registry.yaml`：给现有来源显式登记复核天数。
- Modify `docs/maintenance.md`：规定周期字段、选择依据、到期检查和人工状态更新流程。
- Modify `README.md` and `CHANGELOG.md`：链接本计划并准确记录第四阶段进行中及本次已交付内容。

---

### Task 1: 用回归测试定义新鲜度行为

**Files:** Modify `scripts/test-verify-knowledge-base.sh`。

- [x] 在 fixture 中加入 `review_interval_days: 30`，并让 `run_verifier` 固定设置 `KNOWLEDGE_BASE_TODAY=2026-09-23`。
- [x] 添加缺少周期、非法周期、非法日历日期和未来 `verified_at` 日期的失败断言。
- [x] 添加过期 active 来源断言：`verified_at: 2026-09-12`、周期 30 天、测试日 `2026-10-13` 时应输出该来源 ID 并返回非零。
- [x] 添加边界断言：相同核验日期在 `2026-10-12`（恰好 30 天）时应通过。
- [x] 添加只读断言：过期检查前后 fixture registry 内容完全相同，`status: active` 保持不变。
- [x] 运行 `scripts/test-verify-knowledge-base.sh`，确认新增行为在实现前按预期失败，而不是因测试语法或 fixture 错误失败。

### Task 2: 实现周期校验与到期报告

**Files:** Modify `scripts/verify-knowledge-base.sh` and `sources/registry.yaml`。

- [x] 扩展 registry 解析结果，要求每条来源包含 `review_interval_days`，仅接受 30、90、180、365。
- [x] 实现 BSD/GNU `date` 兼容的 UTC 日期解析；校验 `verified_at` 与覆盖日期均为真实日历日期。
- [x] 仅对 `status: active` 来源计算天数；当年龄严格大于登记周期时，打印来源 ID、核验日期和周期并返回非零。
- [x] 保持检查只读；不得重写来源文件，或自动设置 `review_due`。
- [x] 按被支持内容分类登记当前 17 项来源：`OAI-HARNESS-2026` 为稳定工程原则、365 天；Codex 产品事实来源（`OAI-CODEX-BEST-PRACTICES`、`OAI-AGENTS-MD` 和 10 项 `OAI-CODEX-*` 配置来源）为 30 天；`B-LANGCHAIN-MULTIAGENT-2025` 为作者一手工程案例、90 天；3 项 `A-*` 研究论文为 180 天。维护规范将 90 天档明确扩展为官方或主题作者原始发布的工程实践/案例。逐条核对用途，不按 `level` 或 `stability` 自动推导。
- [x] 重跑 `scripts/test-verify-knowledge-base.sh`，确认 RED 转 GREEN，且所有原有 fixture 仍通过。

### Task 3: 文档化操作流程并标记阶段进度

**Files:** Modify `docs/maintenance.md`, `README.md`, and `CHANGELOG.md`。

- [x] 说明 `review_interval_days` 是人工选择并逐来源登记的治理字段，列出合法周期及对应内容类别；将 90 天周期适用范围明确为官方或主题作者原始发布的工程实践/案例。
- [x] 说明 active 来源过期时验证器如何报告、何时人工复核原始来源，以及验证后如何更新 `verified_at`/`status`；明确检查器不会自动修改状态。
- [x] 在 README 添加本计划入口，将状态标记为第四阶段进行中；不宣称整个阶段已完成。
- [x] 在 CHANGELOG 记录已交付的新鲜度检查，不把尚未完成的官方差异记录、模型升级 holdout 或月度审计写成已完成。

### Task 4: 全量验证与最终审查

- [x] 运行 `scripts/test-verify-knowledge-base.sh`。
- [x] 运行 `scripts/verify-knowledge-base.sh`，使用真实当前日期检查所有登记来源。
- [x] 用 `git diff --check` 检查空白错误，并审查 `git status --short` 与完整 diff。
- [x] 核对来源周期分配、日期边界、BSD/GNU 日期路径、过期报告与无副作用断言；不执行 Git 写操作。

## Completion Criteria

- 所有 registry 来源均有合法的人工登记复核周期；缺失、非法及异常日期均被确定性检查拒绝。
- 活跃且超过复核周期的来源会被报告并令验证失败，但 registry 不会被检查器修改。
- 日期边界和无副作用均由自动化测试覆盖，现有知识库检查保持通过。
- 文档明确说明本计划只交付新鲜度检查；第四阶段其他事项的当前状态由 README 跟踪，不据此宣称整个阶段完成。
