---
name: maintaining-codex-knowledge-base
description: Use when adding, updating, revalidating, or retiring source-backed claims in the Codex best-practices knowledge base, or recording official Codex CLI release differences.
---

# Codex 知识库来源维护

把来源核验、正文更新和复核记录作为一个可追溯流程。只在用户要求维护知识库，或当前任务明确需要更新其中的来源与声明时使用。

## 事实源与来源准入

知识库根目录为 `/Users/chuanchuan/Work/codex`。先读 `docs/maintenance.md`，并以它作为维护规则的唯一依据。Codex 产品事实使用 OpenAI 官方文档、源码、发布说明或系统卡；研究结论使用同行评审论文或作者原始预印本；专家经验使用本人或主办方原始发布。聚合、转载、营销内容和搜索摘要只用于发现来源，不作为证据。

**联网时必须使用 `web-access` Skill。** 实际打开原始页面或论文全文后，才可登记或引用；记录作者/发布方、标题、日期、URL、适用范围及支持的具体声明。无法访问原文或证据不支持声明时，标记 `blocked` 或缩窄声明，不补猜测。

## 工作流程

1. 检查 `/Users/chuanchuan/Work/codex` 的 `git status`，保留已有改动；只改本次来源和声明所需文件。
2. 按维护规范为来源选等级、复核周期和状态；外部事实引用 `sources/registry.yaml` 中唯一的来源 ID。发布日期未知时将 `published_at` 记为 `null`，不要用核验日期替代。
3. 将来源证据与正文逐项对应，区分外部事实和本仓库治理决策。出现无法消解的冲突时标记 `contested`；被新来源替代时标记 `superseded`。
4. 只在本轮重新打开并核验原文后更新 `verified_at`。过期检查器只报告问题，不会代替人工复核或自动改状态；未完成复核时不得把来源伪装成新鲜。
5. 更新受影响的正文、registry、`sources/review-log.md` 和 `CHANGELOG.md`。稳定版 Codex CLI 发布后，对照官方 Releases 的完整 changelog 与上一条记录；首条记录记为基线。无影响时也记录依据，不刷新无关来源日期。
6. 运行 `scripts/test-verify-knowledge-base.sh` 和 `scripts/verify-knowledge-base.sh`，检查退出状态并审阅最终 diff。验证失败时如实报告，不用日期覆盖或修改状态来伪造通过。

## 边界与交付

- 不修改项目外的全局规则、Hooks、记忆、生产设置、锁文件或数据库迁移；不执行 Git 写操作，除非用户明确要求。
- 不把搜索结果摘要当作已核验来源；不因新版本发布而批量刷新 `verified_at`。
- 完成时列出新增或变更的来源 ID、对应声明和文件、验证结果，以及 `blocked`、`review_due` 或 `contested` 项。
