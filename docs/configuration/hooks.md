# Hooks 生命周期钩子

> 本文记录 Codex 配置的易变事实。核验日期：2026-10-21；本机 CLI：`codex-cli 0.163.0`。执行过只读命令 `codex --version` 与 `codex features list`；本机将 `hooks` 标记为 `stable / true`。没有安装或执行任何 Hook 脚本。来源：[OpenAI 官方 Hooks 文档](https://learn.chatgpt.com/docs/hooks) [source:OAI-CODEX-HOOKS-2026]、[Advanced Configuration](https://learn.chatgpt.com/docs/config-file/config-advanced) [source:OAI-CODEX-CONFIG-ADVANCED-2026]

## Hook 做什么

Hook 是在 Codex 生命周期事件发生时触发的处理器，可用于检查工具调用、为会话补充上下文或在结束时做清理。由于 handler 可以运行外部命令，应像审查脚本一样审查其来源、权限、输入与副作用；不要把项目 Hook 自动视为可信代码。[source:OAI-CODEX-HOOKS-2026]

常见事件包括 `SessionStart`、`SessionEnd`、`PreToolUse`、`PostToolUse`、`PermissionRequest`、`PreCompact`、`PostCompact`、`UserPromptSubmit`、`SubagentStart`、`SubagentStop`、`Stop` 和 `Interrupt`。部分事件不会在子 Agent 上触发，部分事件不支持 matcher；写规则前应查官方事件表，不能从事件名推断行为。[source:OAI-CODEX-HOOKS-2026]

## 配置位置

Hook 可用 `hooks.json` 或相邻 `config.toml` 中的 inline `[hooks]` 配置。常见位置有用户级 `~/.codex/hooks.json` / `~/.codex/config.toml`，以及可信项目中的 `.codex/hooks.json` / `.codex/config.toml`。项目级 Hook 随项目 `.codex/` 层一起受信任状态控制；用户级 Hook 不依赖项目是否受信任。若同一配置层同时含 `hooks.json` 和 inline `[hooks]`，Codex 会加载两者并警告，通常应选一种表示方式。[source:OAI-CODEX-CONFIG-ADVANCED-2026] [source:OAI-CODEX-HOOKS-2026]

## 配置结构

下面展示结构，不会在本仓库创建或启用 Hook。将命令路径替换为经审查、确实存在且权限合适的程序后再使用：

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "^Bash$",
        "hooks": [
          {
            "type": "command",
            "command": "python3 ./.codex/hooks/review-command.py",
            "timeout": 30,
            "statusMessage": "Reviewing command"
          }
        ]
      }
    ]
  }
}
```

事件名下面可以包含 matcher 组和一个或多个 handler。`timeout` 以秒计；异步 Hook 使用 `async: true`。当前文档说明命令 Hook 与 MCP tool Hook 受支持；`prompt` 与 `agent` handler 目前虽能解析，但会被跳过。不能仅因配置格式解析成功，就认定 handler 已执行。[source:OAI-CODEX-HOOKS-2026]

## 生命周期与安全

- 非托管 Hook 必须先审核并信任其当前定义才会运行；信任按定义的 hash 记录，新增或修改后会跳过执行，直到重新审核。CLI 的 `/hooks` 用于查看来源、审核、信任或禁用非托管 Hook；启用插件不会自动信任其 Hook。托管 Hook 由策略信任，不能在用户 Hook 浏览器中禁用。[source:OAI-CODEX-HOOKS-2026]
- Hooks 当前默认启用；可通过 `[features] hooks = false` 关闭。CLI 功能列表显示的是当前安装版本的功能阶段与有效状态，更新 CLI 后应重新检查。[source:OAI-CODEX-HOOKS-2026]
- 命令 Hook 在会话的当前工作目录运行；使用稳定的绝对路径或从项目根定位脚本，避免因从子目录启动而运行错文件。[source:OAI-CODEX-HOOKS-2026]
- 命令 Hook 默认超时为多数事件 600 秒；`SessionEnd` 和 `Interrupt` 的默认超时与上限更短。异步 Hook 会后台运行；每个会话最多并发运行八个，`SessionEnd` 始终同步执行。[source:OAI-CODEX-HOOKS-2026]
- Hooks 的输出会按事件合同解释。例：`SessionStart` 的普通 stdout 可变成额外上下文；因此不要输出密钥、私密文件内容或不可信的大段文本。[source:OAI-CODEX-HOOKS-2026]
- 事件失败的影响依 handler 与事件而异。特别是 MCP tool Hook 文档说明，错误、缺失服务器和工具不可用不会阻止操作；不要把 Hook 当作唯一安全边界。[source:OAI-CODEX-HOOKS-2026]

## 验证

1. 执行 `codex --version`，记录 CLI 版本。
2. 执行 `codex features list`，检查 `hooks` 的状态；该命令只核验当前配置下 CLI 报告的功能阶段/有效状态。
3. 查官方事件表核对事件名、matcher、输入输出与超时，并在 `/hooks` 中检查非托管 Hook 的审核状态；只读 `codex --help` 或功能列表不会验证 Hook 脚本是否运行。
4. 如需运行时测试，使用隔离的临时项目和无敏感信息的无害脚本，先审查脚本及匹配条件；本轮没有执行运行时 Hook 测试，标记为 `not_run`。

本机结果为 CLI `0.163.0`、`hooks stable true`。Hook 信任流程、`prompt`/`agent` handler、各事件失败分支及实际脚本执行未在本轮运行验证；后续版本如有变化，应以官方原文和重新执行的 CLI 检查为准。[source:OAI-CODEX-HOOKS-2026]
