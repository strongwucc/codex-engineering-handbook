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
