# 来源核验日志

## 2026-09-12

### 已接纳

- `OAI-HARNESS-2026`：已打开 OpenAI 原始文章；用于知识库结构和 Harness 工程实践。
- `OAI-CODEX-BEST-PRACTICES`：已打开 OpenAI Docs；用于 Codex 工作流和配置分层；页面未公开发布日期，`published_at` 显式记录为 `null`。
- `OAI-AGENTS-MD`：已打开 OpenAI Docs；用于 AGENTS.md 的发现与覆盖语义；页面未公开发布日期，`published_at` 显式记录为 `null`。

### 已拒绝

- 搜索结果摘要：仅用于定位原始页面，不作为证据登记。
- 营销软文：属于 X 级来源，仅可用于发现原始页面，不作为证据登记。
- 旧知识库中的未复核转述：等待逐条回到原始来源后再决定是否迁移。

## 2026-09-23

### 已接纳

- `A-AGENTBENCH-2024`：已打开 [arXiv 原始记录](https://arxiv.org/abs/2308.03688) 和 [ICLR 2024 论文页](https://proceedings.iclr.cc/paper_files/paper/2024/hash/e9df36b21ff4ee211a8b71ee8b7e9f57-Abstract-Conference.html)。作者机构包括清华大学、俄亥俄州立大学和加州大学伯克利分校。按已发表论文归为 A 级；arXiv 页面显示当前为 v3（2025-10-04 更新），评估结论以 ICLR 2024 论文页为准，只用于交互式、多环境 Agent 评测设计。
- `A-SWE-BENCH-2024`：已打开 [arXiv 原始记录](https://arxiv.org/abs/2310.06770) 和 [ICLR 2024 论文页](https://proceedings.iclr.cc/paper_files/paper/2024/hash/edac78c3e300629acfe6cbe9ca88fb84-Abstract-Conference.html)。作者机构包括 Princeton Language and Intelligence、普林斯顿大学和芝加哥大学。按已发表论文归为 A 级；用于真实仓库 issue 任务和执行环境评测设计，不把论文中的历史模型结果当作当前模型能力结论。
- `A-SWE-BENCH-PLUS-2024`：已打开 [arXiv v2 原始记录](https://arxiv.org/abs/2410.06992)。作者机构为约克大学 Lassonde 工程学院。记录显示 v1 于 2024-10-09 提交、v2 于 2024-10-10 修订；当前登记为作者原始预印本，未按同行评审论文表述。其人工审查结果仅作为特定模型/样本下的数据泄漏与测试质量风险案例，不外推为 SWE-bench 的普遍发生率。
- `B-LANGCHAIN-MULTIAGENT-2025`：已打开 [LangChain 原文](https://www.langchain.com/blog/benchmarking-multi-agent-architectures) 及其链接的 [实验代码仓库](https://github.com/hinthornw/mabench) 和 [LangChain supervisor 实现仓库](https://github.com/langchain-ai/langgraph-supervisor-py)。原文由 LangChain Team 发布并署名 Will Fu-Hinthorn；作者直接报告了自己对多 Agent 架构的实验及实现，符合本仓库 B 级一手工程分享准入。实验基于改造后的 τ-bench、GPT-4o 和 100 条 retail test 样例，结论只作特定设置下的案例，不推广为通用架构排名。

### 已拒绝

- LangChain 的 [Benchmarking Question/Answering Over CSV Data](https://www.langchain.com/blog/benchmarking-question-answering-over-csv-data)：原文已打开，但主题聚焦表格问答应用，与本阶段的通用 Agent/Harness 评估关联不足；不纳入本轮正式证据。
