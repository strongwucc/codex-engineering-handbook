# Superpowers 来源统一与版本对照记录

日期：2026-10-22（来源调查）；A/B 续跑日期：2026-10-23。来源调查和最小配置修改已完成。首次运行曾被运行时隔离和网络预检阻断；后续用户停用远程插件后，六项小样本任务完成并通过验收。用户随后报告已重新启用 Superpowers；最新探测只手动读取了旧共享文件，不能证明插件已加载。实际插件状态和新会话加载路径仍待核验。当前结果及隔离证据见[续跑报告](continued-status-2026-10-23.md)，不据此排列版本优劣。

## 来源调查

- `~/.agents/.skill-lock.json` 将独立的 `using-superpowers` 登记为从 `obra/superpowers` 的 `skills/using-superpowers/SKILL.md` 安装，安装和更新时间均为 `2026-03-20T06:22:13.352Z`。记录未包含具体命令和发布版本，不能还原当时由哪个客户端发起安装。
- Claude 的 `~/.claude/skills/using-superpowers` 是软链接，目标为 `../../.agents/skills/using-superpowers`。两者解析到同一文件、inode 和 SHA-256；不是两份独立正文。
- Claude 另有原生插件 `superpowers@claude-plugins-official`，安装登记为 2026-03-26，当前登记版本为 `7.0.0`。
- 10 月 22 日调查时，Codex 会话技能目录和插件清单指向 `openai-curated-remote/superpowers/6.4.2`；10 月 23 日续跑从 Codex 插件缓存取得 7.0.1 快照。
- 因此，可确认的是“旧共享入口加各客户端原生插件”的重复发现来源。记录支持旧入口直接来自 GitHub，不能认定它是从 Claude 插件缓存复制过来的。

必要的原始登记字段和旧文件摘要见 [provenance.json](provenance.json)。未复制其他技能登记或用户配置全文。

## 已执行的最小修改

Codex 的 `~/.codex/config.toml` 末尾新增：

```toml
# Superpowers: use the native plugin; keep the shared skill for other clients.
[[skills.config]]
path = "/Users/chuanchuan/.agents/skills/using-superpowers"
enabled = false
```

同时，将 Claude 的旧软链接移入备份目录。保留共享技能正文，避免改变其他可能使用共享目录的客户端；未修改 `.skill-lock.json`，未升级任何插件。

备份目录：`/Users/chuanchuan/.codex/backups/superpowers-source-unification-20261022/`，包含 `config.toml.before`、`claude-using-superpowers.symlink` 和 `receipt.json`。归档软链接的相对目标只用于恢复到原路径，在备份目录中不代表可用技能入口。

恢复时，应仅撤回上述配置块，并把归档软链接移回原路径；若之后配置已有其他变化，不应直接覆盖整个配置文件。

验证结果：

- `passed`：Python 3.13 `tomllib` 成功解析修改后配置，旧入口恰有一个 `enabled = false` 覆盖。
- `passed`：Claude 旧软链接已离开发现目录，原生插件仍存在。
- `passed`：共享技能正文仍存在，旧技能安装登记与修改前一致。
- `passed`：配置 diff 仅包含上述新增块。
- `blocked`（10 月 22 日）：新会话实际提示输入检查报 `sandbox-exec: sandbox_apply: Operation not permitted`。该次没有证明配置文件已在新会话生效；10 月 23 日的隔离运行路径检查另见下文续跑结果。

逐技能停用配置的语义依据本轮实际打开的 [OpenAI 配置参考](https://learn.chatgpt.com/docs/config-file/config-reference)。

## 版本文件对比

使用本机已有的 `6.4.2` 和 `7.0.0`，比较 15 个 `SKILL.md`：12 个正文相同，3 个不同。

- `brainstorming`：从 17548 字节变为 10073 字节，并改变了交互与任务分级流程。内容缩短不能证明任务效果更好。
- `systematic-debugging`：修改环境变量诊断示例，避免原示例直接输出变量值。
- `requesting-code-review`：修改示例中的 shell 字段提取命令。
- `using-superpowers` 正文相同，仍保留低阈值强制技能调用规则。升级到 `7.0.0` 本身不会消除该规则。

统计只覆盖上述入口正文，不把其他脚本、引用或资源视为相同。完整文件摘要见 [skill-snapshot-sha256.json](skill-snapshot-sha256.json)，正文统计见 [skill-comparison.json](skill-comparison.json)。差异见 [brainstorming.diff](brainstorming.diff)、[systematic-debugging.diff](systematic-debugging.diff)、[requesting-code-review.diff](requesting-code-review.diff)。

上游发布页在本轮调查显示最新正式版为 `7.0.1`；发布说明记录了对 `7.0.0` 的提问流程和长技能内容的修正：[上游发布记录](https://github.com/obra/superpowers/releases/tag/v7.0.1)。10 月 22 日下载 `7.0.1` 时，普通执行和提权执行均遇到 DNS 解析失败；10 月 23 日续跑使用了 Codex 插件缓存中的 7.0.1 技能快照，故该版本已纳入本次任务对照。

## 小范围模型对照

10 月 22 日的首次任务因工作区路由预检失败而阻断；后续运行也曾因把插件缓存目录存在误判为技能已读取而停止。用户停用远程插件后，runner 改为根据事件日志里的技能文件读取路径判定泄漏，并从已通过的 baseline T02 续跑。

10 月 23 日续跑以 baseline、7.0.0、7.0.1 对照 T01/T02，共六项。模型、现有测试、独立验收的退出码均为 0；三组各自两项验收均通过。baseline 未读取 Superpowers 技能文件，两个技能版本只读取各自 profile 内快照的技能文件。临时 `CODEX_HOME` 中仍有插件缓存，但缓存目录存在本身不作为加载证据。

该实验每组只有两个不同任务且每项运行一次，只能说明本轮任务均通过；不能据此确认质量提升或形成稳定性能排名。首次阻断记录仍保留在 [comparison-protocol.json](comparison-protocol.json)，当前六项明细、token/耗时和来源限制见[续跑报告](continued-status-2026-10-23.md)。原始运行文件位于 `/private/tmp/superpowers-ab-20261023/`，摘要为 `summary-20261023T141525Z-75521.tsv`。
