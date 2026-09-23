# 模型升级练习集 v1：评估者评分表

**评估者专用。不得挂载到被测 Agent 工作区，也不得与其共享本文件或 `evaluator-tests/`。**

每项按真实结果记录 `passed`、`failed`、`blocked` 或 `not_run`，并附原始输出和变更 diff。不要把分数合并为平均值，也不要以任务集结果代替真实项目的 holdout 评估。

| 任务 | 验收依据 | 基线预期 | 变更范围观察 |
|---|---|---|---|
| T01 | `evaluator-tests/v1/T01-stock-underflow.test.js` | `failed`：未拒绝负库存 | 是否保留已有校验且不改输入 |
| T02 | `evaluator-tests/v1/T02-inventory-filter.test.js` | `failed`：API 尚不存在 | 过滤语义、顺序及副本行为 |
| T03 | `evaluator-tests/v1/T03-low-stock-boundary.test.js` | `failed`：未包含等于阈值项 | 是否只修复边界并保留副本 |
| T04 | `evaluator-tests/v1/T04-csv-escaping.test.js` | `failed`：特殊字段未转义 | CSV 转义、表头及行尾行为 |

针对每个基线/候选、每项任务使用独立干净副本。先运行副本自带的 `node --test`，再从评估者环境运行对应验收测试；通过 `CORE_WORKSPACE` 指向该副本。验收脚本和本评分表不得复制进被测工作区。
