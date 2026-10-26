# Superpowers A/B 续跑结果

日期：2026-10-23。状态：六项任务均完成；模型、现有测试和独立验收退出码全部为 0。这是小样本冒烟对照，不支持版本排名。

## 运行条件

- 摘要：`/private/tmp/superpowers-ab-20261023/summary-20261023T141525Z-75521.tsv`
- 模型：`gpt-6.1-sol`，推理强度 `medium`；Codex CLI：`0.163.0`
- 组别：baseline、Superpowers 7.0.0、Superpowers 7.0.1；任务：T01、T02；每组每任务一次。
- baseline T02 复用了插件停用后完成的 `attempt-3`；其余五项由续跑完成。

## 技能来源隔离

- baseline T01、T02 的事件日志均没有读取 Superpowers `SKILL.md` 的命令。
- 7.0.0 和 7.0.1 的事件日志只显示读取各自运行 profile 下 `.agents/skills/` 的技能文件；六项结果中的 `skill-source-check.txt` 均记录 `out_of_profile_skill_read=none`。
- 三个临时 `CODEX_HOME` 仍出现远程 Superpowers 缓存目录。目录存在本身不等于技能被读取；本轮可观察的文件读取路径符合隔离条件。此结论限于事件日志记录到的命令，不证明宿主侧不可观察的插件元数据状态。

## 结果与资源

| Profile | T01/T02 验收 | 输入 token 合计 | 输出 token 合计 | 模型耗时合计 |
|---|---:|---:|---:|---:|
| baseline | 2/2 | 121,877 | 1,634 | 210 秒 |
| 7.0.0 | 2/2 | 266,266 | 2,509 | 268 秒 |
| 7.0.1 | 2/2 | 299,070 | 2,849 | 237 秒 |

- T01 三组最终改动相同：只在 `adjustStock` 更新后拒绝负库存，并抛出 `RangeError`；没有把测试文件改动留在最终补丁中。
- T02 三组都实现并导出 `filterInventory`，并向现有测试文件增加筛选测试。表达方式和测试细节略有差异，三组现有测试与独立验收均通过。
- baseline T02 和 7.0.1 T01 各出现一次 `Reconnecting... 2/5`，随后均成功完成。重连和样本量都限制了耗时解读。

## 结论与限制

本轮任务中没有观察到不同组的验收结果差异；技能组的输入 token 明显更高，但两项任务、每项一次运行不足以推断这部分差异会稳定出现，也不足以得出技能是否提升质量的普遍结论。建议把结果视为“当前两个任务都通过，质量差异未测出”，不要据此宣布 7.0.0 或 7.0.1 更优。

原始事件、最终补丁、测试日志和来源检查分别保存在摘要 TSV 指向的各 `attempt-*` 目录。先前被插件状态污染或在预检阶段阻断的运行仍保留作历史记录，不纳入本表。

## 重新启用后的运行态核验

用户报告已重新启用 Superpowers。当前本机可确认：旧共享 `using-superpowers` 路径仍在 `~/.codex/config.toml` 中禁用，Codex 插件缓存有 7.0.1 目录和远程插件安装标记。`codex plugin list --json` 未能取得远程插件目录；命令列出的本地插件不能证明 Superpowers 当前是否启用。

本机启动的只读新会话在 `workspace routing discovery failed` 后以 `turn.failed` 结束。之后用户在普通 Terminal 执行的探测返回了 `/Users/chuanchuan/.agents/skills/using-superpowers/SKILL.md`。事件显示模型执行了一个硬编码路径循环，依次检查 `~/.codex/skills/` 和 `~/.agents/skills/`，再用 `cat` 读取找到的文件；它没有查询会话技能目录，也没有读取 Codex 插件缓存里的 7.0.1 文件。

因此，这次输出只证明共享文件仍可被显式 shell 命令读取，不证明它被 Codex 自动加载；`enabled = false` 不会禁止 shell 显式读取文件。也没有证据确认原生插件在新会话可调用或实际加载 7.0.1。第 1 步验收仍未通过，远程目录查询恢复后应先用插件清单确认启用状态，再用不手动搜索文件路径的原生技能调用检查实际读取路径。不要把本次路径输出当作通过，也不要因此改动来源配置。
