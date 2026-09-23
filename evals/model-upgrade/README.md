# 模型升级独立练习集

练习集 `v1` 使用独立的 `core-v1` 小型 Node.js 项目，不依赖第三方包，也不修改知识库的核心规则或用户全局配置。四项任务分别覆盖 bug 修复、小功能、边界诊断和边缘输入处理。

## 隔离执行

1. 固定本轮任务 ID、基线模型/配置、候选模型及隔离 profile；基线和候选必须使用同一任务集、提示文本版本与运行环境。
2. 对每个模型、每项任务，从 `core-v1/` 新建一个干净工作副本，只向被测 Agent 提供该副本和对应的一个 `tasks/v1/Txx-*.md`。不要提供其他任务、`evaluator-tests/`、`evaluator-scorecard-v1.md` 或 `evals/holdout.md`。
3. 在副本内运行 `node --test`。评估者在隔离的评估环境中另行运行该任务的验收测试，例如：

   ```bash
   CORE_WORKSPACE=/absolute/path/to/candidate-copy node --test evals/model-upgrade/evaluator-tests/v1/T01-stock-underflow.test.js
   ```

4. 基线与候选分别留存原始输出、退出状态、任务前后 diff、运行时/CLI/配置版本、耗时和可观测资源计数。不可观测项如实注明；不要汇总成无依据的总体分数。

验收测试以独立进程指向工作副本，不需要安装包。执行者应确保测试目录和评分表不会出现在 Agent 可访问的工作区或上下文中。任务集结果只用于受控对照，不等同于真实项目能力结论。当前仓库只准备了协议与夹具，未运行任何模型对照。
