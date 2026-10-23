# 本项目维护的技能

这里保存依赖本知识库的技能正文与配套脚本，使它们和知识库内容一起审查、维护。

| 技能 | 用途 |
| --- | --- |
| [codex-harness-evaluate](codex-harness-evaluate/SKILL.md) | 按本知识库的九维标准评估指定项目 |
| [configuring-codex-projects](configuring-codex-projects/SKILL.md) | 参考本知识库为开发项目配置 Codex |
| [maintaining-codex-knowledge-base](maintaining-codex-knowledge-base/SKILL.md) | 核验和维护本知识库的来源与声明 |

本机原有的 `~/.codex/skills/<技能名>` 入口链接到这里，因此其他项目仍可调用这些技能。修改正文时直接编辑本目录；不要再维护独立副本。

本目录使用 `skills/`，保留现有全局入口的作用域。迁移仅改变正文位置，未改写技能中的本机路径；迁到另一台机器时，需要先检查这些路径。

通用技能、第三方技能和插件缓存分别由各自来源维护，不纳入本目录。

验证配套取证脚本：

```bash
python3 skills/codex-harness-evaluate/scripts/test_collect_evidence.py
```
