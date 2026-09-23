# Codex Skills

> 本文记录 Codex 配置的易变事实。核验日期：2026-09-23；本机 CLI：`codex-cli 0.156.0`。执行过只读检查 `codex --version` 与 `codex --help`；未启动会话测试 `$` 或 `/skills`。来源：[OpenAI 官方 Build skills 文档](https://learn.chatgpt.com/docs/build-skills) [source:OAI-CODEX-SKILLS-2026]

## Skill 是什么

Skill 是一个包含 `SKILL.md` 的目录；`SKILL.md` 必须含有 `name` 与 `description`。目录还可以带 `scripts/`、`references/`、`assets/` 等支持文件，或 `agents/openai.yaml` 等可选 UI 元数据。[source:OAI-CODEX-SKILLS-2026]

```text
.agents/skills/<skill-name>/
├── SKILL.md                 # 必需：元数据和指令
├── scripts/                 # 可选：可执行辅助脚本
├── references/              # 可选：详细参考材料
└── assets/                  # 可选：模板和资源
```

最小 `SKILL.md` 结构：

```markdown
---
name: release-check
description: Release 前检查变更、验证结果和发布说明。
---

# Release check

说明该工作流的步骤、边界和完成条件。
```

## 本地发现范围

Codex 官方文档列出的本地 Skill 位置包括：[source:OAI-CODEX-SKILLS-2026]

- **仓库级**：当前工作目录及其父目录到仓库根目录路径中的 `.agents/skills/`；适合提交给团队共享的仓库工作流。
- **用户级**：`$HOME/.agents/skills/`；适合跨仓库复用的个人工作流。
- **管理员级**：`/etc/codex/skills/`；适合机器或容器提供的共享默认项。
- **系统级**：由 Codex 系统环境提供的 Skills；不应假设其本地文件可由用户修改。

同名 Skill 不会合并；重名项仍可能同时出现在 Skill 选择器中，因此团队 Skill 应使用清晰、可区分的名称。变更通常会自动检测；如果新内容未出现，再启动 Codex 新会话。[source:OAI-CODEX-SKILLS-2026]

## 如何触发

- **显式调用**：在 Codex CLI 中使用 `$` 提及 Skill，或在会话中使用 `/skills` 选择。
- **隐式调用**：Codex 可根据任务与 `description` 的匹配选择 Skill。

Skill 的名称和描述会先进入可用列表；需要使用时再载入完整 `SKILL.md`。因此，`description` 要短而具体，说明触发任务和边界，不要写成宽泛的角色口号。[source:OAI-CODEX-SKILLS-2026]

本机 `codex --help` 没有单独的顶层 `skills` 管理子命令；显式提及和 `/skills` 入口来自官方产品文档，本轮未启动模型会话实测。[source:OAI-CODEX-SKILLS-2026]

## 如何组织内容

- 将必要的触发条件、工作流指令和安全边界放在 `SKILL.md`。
- 把长篇背景或特定任务参考放到 `references/`，让入口说明保持聚焦。
- 仅在确实需要可执行辅助逻辑时加入 `scripts/`；调用前检查脚本内容和副作用。
- 描述清楚 Skill 适用与不适用的任务，避免和同目录其他 Skill 抢相同触发范围。

前三项目录用途是官方文档定义的结构说明；最后一项属于本知识库的编写建议，目标是降低隐式触发歧义。[source:OAI-CODEX-SKILLS-2026]

## 验证

1. 检查目录名、`SKILL.md` front matter 的 `name`/`description` 和实际文件路径。
2. 执行 `codex --version` 记录 CLI 版本；阅读官方 Skills 文档确认该版本应支持的发现与调用方式。
3. 在隔离的新会话中显式调用一次，并用一个符合 `description` 的任务检查隐式触发；不要仅凭文件存在或 `codex --help` 就宣称调用成功。
4. 如果更新未显示，重启 Codex；不要为排错输出无关的用户级 Skill 内容。

本轮验证到 CLI 版本及顶层帮助内容，没有实际调用 Skills，因此 Skill 发现和触发行为标记为 `not_run`。[source:OAI-CODEX-SKILLS-2026]
