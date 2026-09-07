# Templates

本目录提供新项目骨架和共享接口模板。

- 这些文件是示例起点，不应机械照搬所有实现。
- 所有模板都遵守单文件单主类型规则。
- 共享组件和 AI 能力的命名、分层、依赖方向都以这里为准。
- 根目录 `swift test` 会编译本目录全部 Swift 源码并执行 `Tests/AITests` 中的策略测试。
- 默认 AI client 明确报错，默认 fallback 会继续抛错；只有产品明确允许时才能配置静态降级。
- `InMemoryAIResultCache` 只支持 `.ephemeral`，`.persisted` 必须注入真正的持久化实现。
