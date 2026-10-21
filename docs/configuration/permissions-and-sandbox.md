# 权限、审批与沙箱

> 本文记录 Codex 配置的易变事实。核验日期：2026-10-21；本机 CLI：`codex-cli 0.163.0`。已执行只读检查：`codex --version`、`codex --help`、`codex sandbox --help`；没有执行被沙箱包裹的命令或实际越权测试。来源：[Sandbox](https://learn.chatgpt.com/docs/sandboxing) [source:OAI-CODEX-SANDBOXING-2026]、[Agent approvals & security](https://learn.chatgpt.com/docs/agent-approvals-security) [source:OAI-CODEX-APPROVALS-SECURITY-2026]、[Permissions](https://learn.chatgpt.com/docs/permissions) [source:OAI-CODEX-PERMISSIONS-2026]、[Configuration Reference](https://learn.chatgpt.com/docs/config-file/config-reference) [source:OAI-CODEX-CONFIG-REFERENCE-2026]

## 三个不同的控制面

- **沙箱/权限配置**：限制命令可读写的文件系统范围，以及命令是否可访问网络。
- **审批策略**：决定 Codex 在何时暂停并请求人工批准。`on-request` 会在需要越过当前边界时请求批准；`never` 表示不暂停等待用户批准，本身并不会扩大沙箱边界。
- **其他工具的访问策略**：Web 搜索、MCP、浏览器、应用连接器和 Codex 服务请求各有自己的控制项；命令网络 allowlist 不是所有工具的全局网络策略。

这些设置互相补充，不能互相替代。特别是减少审批提示，不等于建立了更强的隔离。[source:OAI-CODEX-SANDBOXING-2026] [source:OAI-CODEX-APPROVALS-SECURITY-2026] [source:OAI-CODEX-PERMISSIONS-2026]

## 常见沙箱模式

| 模式 | 主要边界 | 适用说明 |
|---|---|---|
| `read-only` | 允许检查文件；写入和沙箱外操作受限 | 适合只读探索与审查 |
| `workspace-write` | 可读写活动工作区并运行常见本地命令；越过工作区边界的操作受限 | 适合常规仓库修改；可写根目录之外的权限仍需另行授予 |
| `danger-full-access` | 移除本地沙箱限制 | 仅在明确需要广泛本机访问时使用；不要作为日常默认值 |

可写根目录内仍可能存在显式拒绝或受保护路径；批准命令或请求文件系统提权，不代表这些拒绝和网络限制自动解除。官方 `0.159.0` 与 `0.161.0` 发布说明记录了相关限制保留行为。[source:OAI-CODEX-CLI-RELEASES-2026]

Codex 依据操作系统使用不同的执行隔离机制；macOS、Linux/WSL 与原生 Windows 的实现及可强制策略并不相同。沙箱无法替代最小权限、代码审查或对运行环境的隔离；不要把某一平台的测试结果推广为所有平台的保证。[source:OAI-CODEX-SANDBOXING-2026] [source:OAI-CODEX-PERMISSIONS-2026]

## 审批策略

- `on-request`：Codex 在当前沙箱范围内工作；需要超出边界时请求批准。
- `never`：不再等待人工审批提示。它不是“安全模式”，也不会自动把 `read-only` 变成可写；风险取决于同时生效的沙箱与其他权限。
- `untrusted`：已退休，不应继续作为当前配置值；旧配置保留该值可能导致客户端无法启动。迁移时应依据官方文档选择当前支持的策略。

如果使用自动审批审查，`approvals_reviewer = "auto_review"` 只审查原本需要批准的请求；它不会改变沙箱边界。无审批且无沙箱的“full access”组合风险很高，不建议用于常规任务。[source:OAI-CODEX-APPROVALS-SECURITY-2026] [source:OAI-CODEX-SANDBOXING-2026]

## 两种配置方式

传统配置示例：

```toml
sandbox_mode = "workspace-write"
approval_policy = "on-request"
```

当前官方文档还介绍了 named permission profiles，例如内置 `:read-only`、`:workspace` 和 `:danger-full-access`，通过 `default_permissions` 选择 profile。不要把 profile 名称和 `sandbox_mode` 的枚举值混为一谈；先检查当前 CLI 版本和组织管理策略，再按配置参考设置。[source:OAI-CODEX-PERMISSIONS-2026] [source:OAI-CODEX-CONFIG-REFERENCE-2026]

`codex --help` 在本机 `0.163.0` 中确认 `--sandbox` 提供 `read-only`、`workspace-write`、`danger-full-access`，并列出 `--ask-for-approval`；`codex sandbox --help` 列出 `--permission-profile`。以上只证明 CLI 接受这些参数，不证明某一命令在特定 OS、容器或组织策略下的实际隔离效果。[source:OAI-CODEX-SANDBOXING-2026] [source:OAI-CODEX-APPROVALS-SECURITY-2026]

## 网络权限不要混为一谈

Permission profile 的命令网络访问与域名过滤是相关但独立的设置：`permissions.<name>.network.enabled` 控制命令网络是否开放，`features.network_proxy` 及域名规则用于代理过滤。Web 搜索、MCP、浏览器和 Codex 服务流量有单独的控制面；开关命令网络不会自动限制或授权这些其他能力。[source:OAI-CODEX-PERMISSIONS-2026]

## 验证和边界

1. 执行 `codex --version`，记录版本；用 `codex --help` 核对该版本接受的 `--sandbox` 和审批参数。
2. 使用 `codex sandbox --help` 检查本机 CLI 暴露的沙箱子命令与 profile 参数。
3. 变更配置后在非生产、可丢弃的测试环境中验证实际行为；不要用破坏性命令测试权限边界，也不要仅凭参数被解析就宣称隔离已生效。
4. 处理容器、企业策略、Windows 或网络代理时，额外核对对应平台和管理员配置；受限环境可能影响实际执行路径。

本轮只核验 CLI 参数帮助，没有运行命令级沙箱实验；实际文件与网络访问效果标记为 `not_run`，以当前官方文档作为配置依据。[source:OAI-CODEX-SANDBOXING-2026] [source:OAI-CODEX-PERMISSIONS-2026]
