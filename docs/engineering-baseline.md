# Engineering Baseline

## 目标

让 starter kit 的规则不只停留在文档里，而是能被脚本、CI 和模板持续执行。

## 必须具备的工程基线

- `SwiftLint`、`SwiftFormat` 或等价规范化脚本
- CI 检查流程
- 最小构建与测试命令
- 最低 iOS 版本、Swift 版本和严格并发级别说明
- 本地化资源模板
- AI 测试桩和 fixture 目录

## 推荐最小 CI 步骤

1. 运行 `scripts/check-project-conventions.sh`
2. 运行 `scripts/check-component-registry.sh`
3. 运行格式或 lint 检查
4. 用 `swift test` 编译完整模板并运行 AI 策略测试
5. 把最小示例作为外部依赖消费者再次构建和测试

## SwiftUI / Concurrency 基线

- 所有 UI 驱动 ViewModel 默认 `@MainActor`
- 可跨任务传递的值类型优先 `Sendable`
- 共享可变状态必须由 `actor` 或明确的全局 actor 保护
- 异步服务必须支持取消
- Debug 和 Release 的依赖注入、日志、AI provider 选择要可见

## Localization 基线

- 使用 `Localizable.xcstrings` 或统一文案出口
- 页面和共享组件中不直接写用户文案
- 至少提供一个示例本地化资源文件和调用方式

## AI 基线

- `AIRequestContext` 必须覆盖 timeout、retry、cancellation、telemetry、cache policy
- 至少提供一个 fake client
- 至少提供一组 fixture
- 至少提供 request roles、decode、fallback、timeout、retry、cancellation、telemetry、cache 的真实测试
