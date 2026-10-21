# Changelog

## Unreleased

### Changed

- README 按使用场景整理入口，补齐三个衍生 Skills 的用途与调用示例、配套脚本和评测材料，说明用户级工具的位置、迁移依赖及当前验证范围。
- 2026-10-21：重新核验 13 项 Codex 产品来源，修复两项到期来源的证据基线；保留未复核的论文与工程案例日期。
- 配置教程同步本机 CLI `0.163.0` 的只读观察；补充组织强制要求独立于配置优先级的边界、非托管 Hook 的定义信任审核，修正 `/subagents` 入口及自定义 Agent 不能覆盖父会话权限的说明。
- 追加 `0.157.0` 至 `0.163.0` 七个稳定版的官方差异与影响记录；权限教程补充显式拒绝仍受保护的边界。期间稳定补丁列表因官方 API 访问受阻未能完整枚举，记录为 `blocked`。
- 修复 macOS BSD `date` 沿用当前时分秒导致的新鲜度检查误判：日期统一转换为 UTC 零点；新增零点归一化和核验当日允许通过的回归测试。

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
- 第四阶段模型升级准备：新增独立、无第三方依赖的 Node.js 练习基线、四项隔离任务及评估者验收测试；尚未运行模型对照，不代表升级回归已验证。
