# Codex 知识库工作协议

## 项目地图

- `README.md`：读者入口和当前状态。
- `docs/maintenance.md`：来源准入、复核和失效规则。
- `docs/principles.md`：稳定工程原则。
- `docs/evaluation-standard.md`：九维度评估标准与生产门槛。
- `docs/configuration/`：经过官方文档和当前 CLI 验证的配置教程。
- `docs/platform/`：模型和版本相关的易变事实。
- `sources/registry.yaml`：正式来源登记。
- `evals/fixtures/`：单项评估任务输入；按隔离协议逐项提供。
- `evals/model-upgrade/`：独立模型升级练习集；评分表和验收测试仅供评估者使用。
- `evals/holdout.md`：评估者专用评分依据，不得提供给被测 Agent。
- `templates/evaluation-report.md`：评估报告模板。
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
