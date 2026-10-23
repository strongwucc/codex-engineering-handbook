---
name: codex-harness-evaluate
description: Use when a user asks to assess, audit, or review a specific project's Codex Harness against this knowledge base's nine-dimension standard; not for ordinary code review or general Codex questions.
---

# Codex Harness 评估

对指定项目做证据化评估，帮助识别 Harness 的优势、风险和可执行改进项。默认只读；先收集证据，再评分，不用文件存在或单次成功推断实际能力。

## 唯一评估依据

以 `/Users/chuanchuan/Work/codex` 为本机知识库根目录。每次评估读取其 `docs/evaluation-standard.md` 和 `docs/principles.md`；报告按 `templates/evaluation-report.md`。只在执行 Holdout 时读取 `evals/holdout.md`，评分依据不得进入被测 Agent 的工作区或上下文。不要回退到其他仓库、旧版维度或记忆中的评分标准；知识库缺失时标记 `blocked`。

## 工作流

1. 从请求确定项目路径、评估范围及模式；未指定项目路径时使用当前工作目录并注明。评估前后分别记录 `git status --porcelain=v1`，只读模式下核实状态未变。
2. 运行证据收集器：

   ```bash
   python3 /Users/chuanchuan/.codex/skills/codex-harness-evaluate/scripts/collect_evidence.py <项目路径> --framework-dir /Users/chuanchuan/Work/codex [--skip-global]
   ```

   收集器只列证据，不评分；输出前会对配置敏感值脱敏。需要仅评项目时传 `--skip-global`。
3. 按当前评估标准的九个维度逐项判断。区分项目级、用户全局、当前有效、可移植性四层；记录 `observed`、`no_mechanical_evidence`、`blocked` 或 `not_run`。当前有效配置必须来自本轮可观察证据，不从配置文件推断。
4. 每个可评分维度使用 1–5 星，附直接 `文件:行号` 证据和扣分原因；证据不足则标“无法评分”。总体不算平均分。生产级门槛为安全至少 4 星、测试与验证和 CI/CD 均至少 3 星；关键门槛为 `blocked` 或 `not_run` 时不得确认生产级。
5. 仅在用户要求运行评估任务时使用 `evals/fixtures/`，一次只向被测 Agent 提供一个任务。被测任务与评分依据分开；不可把 Holdout 答案、评估者测试或评分表放进被测工作区。
6. 报告按模板说明范围、九维证据、Holdout 状态、优势、优先改进项、生产门槛、验证记录和限制。检查或模型、CLI 版本无法确认时如实说明，不补猜测。

## 边界

- 不读取或输出 `.env`、密钥、令牌、密码等敏感值；引用配置时先脱敏。
- 不修改项目、用户配置或知识库，不执行 Git 写操作、迁移、部署或生产数据操作。
- 只有用户明确要求 `--run-checks` 时，才运行项目内已有且安全的检查；逐项报告真实退出码。
- 只有用户明确要求 `--write-report` 时，才写入 `.harness-evaluations/YYYY-MM-DD-codex.md`；目标文件已存在则先报告覆盖风险并等待确认。
- 将评估结论限制在本轮项目、模型、Harness、任务与环境证据内；基准结果不外推为普遍能力。

## 输出

开头注明项目、日期、知识库基线、模型与 Codex 版本（仅限实际确认项）及评估模式。随后给出九维结果、项目级与用户全局能力区别、Top 3 优势、Top 3 改进项、生产门槛、验证和限制，最后标记 `done`、`blocked`、`awaiting_approval` 或 `needs_human_decision`。
