# AI-First Rules

## 目标

让项目可以安全、稳定、可替换地使用 AI，而不是把模型调用散落到各个页面和 ViewModel 中。

## 分层

推荐接口：

- `AIClient`: 底层 provider 适配器
- `AICapability`: 任务级能力接口
- `PromptBuilder`: prompt 构造器
- `ResponseSchema`: 输出 schema 定义
- `ResponseDecoder`: 结构化解析器
- `AIResultCache`: 结果缓存
- `AIFallbackPolicy`: 失败回退策略
- `AIRequestContext`: 超时、追踪、调用来源、用户环境
- `AITelemetry`: 统一遥测事件出口

## 规则

### 页面与 ViewModel

- 不允许直接拼 prompt
- 不允许直接访问模型 SDK
- 只能调用 capability 层

### Prompt

- 必须集中定义
- 必须可版本化
- 必须支持 fixture 测试
- 不得混入不必要的敏感数据

### Structured Output

- 必须定义 schema
- decode 失败必须有 fallback
- 展示给用户前必须经过 user-safe mapping

### Runtime Policy

每次 AI 调用都必须定义：

- timeout
- retry policy
- cancellation behavior
- telemetry
- cache policy
- user-safe metadata

### Provider Independence

- Feature 和 ViewModel 不得感知具体 provider
- 同一 capability 应可切换 provider 实现
- provider 差异只能停留在 `AIClient` 层

## 测试要求

至少覆盖：

- prompt builder 生成结果
- schema decode 成功路径
- schema decode 失败回退路径
- cache 命中和失效策略
- provider 失败时 fallback 生效
- request context 是否带齐 timeout / telemetry / cache policy

## 推荐目录

```text
Shared/AI/
├── AIClient.swift
├── AICapability.swift
├── AIRequestContext.swift
├── AIResultCache.swift
├── AIFallbackPolicy.swift
├── PromptBuilders/
├── Schemas/
└── Providers/
```
