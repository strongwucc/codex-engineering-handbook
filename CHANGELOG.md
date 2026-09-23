# Changelog

## Unreleased

### Added

- 知识库设计规格和第一阶段实施计划。
- 严格来源准入、声明级引用和新鲜度规则。
- 首批已核验的 OpenAI 官方来源。
- 知识库导航和 Codex 工作协议。
- 第一阶段确定性验证器及其成功、失败路径测试。
- 第二阶段稳定原则、九维评估标准、H01-H10 holdout 隔离协议和评估报告模板。
- 来源基线新增 AgentBench、SWE-bench、SWE-Bench+ 作者预印本及 LangChain 多 Agent 一手案例，并记录评审状态与适用边界。
- 第二阶段验证：`scripts/test-verify-knowledge-base.sh` 与 `scripts/verify-knowledge-base.sh` 于 2026-09-23 通过。
- 第三阶段新增 AGENTS.md、配置层级、权限与沙箱、Hooks、Skills、多 Agent 六篇配置教程及对应 OpenAI 官方来源核验记录。
- 第三阶段验证：`scripts/test-verify-knowledge-base.sh` 与 `scripts/verify-knowledge-base.sh` 于 2026-09-23 通过。
- 第四阶段启动：17 项来源登记人工选择的复核周期；验证器会报告并阻止未复核的过期 active 来源，但不会自动修改 registry 状态。
- 第四阶段官方发布差异记录启动：登记 OpenAI 官方 Codex CLI Releases 来源，并完成 `0.155.0 → 0.156.0` 首条影响评估；保持未受影响教程不变，后续按 stable release 追加复核记录。
