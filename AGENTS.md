# iOS SwiftUI AI-First Project Rules

本文件是新项目的统一入口规范。所有 AI coding agent 和开发者都必须先读本文件，再开始实现。

## 1. 基本目标

- 项目必须是可复用、可扩展、可被 AI 持续维护的 SwiftUI 工程。
- 通用能力必须先抽象，再在业务中复用。
- 新代码必须优先提升共享层能力，而不是在业务页重复实现。

## 2. 目录职责

- `App/`: App 入口、依赖注入、路由、环境装配
- `Features/`: 按业务能力拆分的模块
- `Shared/DesignSystem/`: 通用 UI、样式 token、modifier、交互反馈
- `Shared/Core/`: 模型、错误、服务、持久化、日志
- `Shared/AI/`: AI provider 抽象、prompt、schema、cache、fallback
- `Shared/Platform/`: 权限、相机、分享、剪贴板、平台桥接
- `Localization/`: 文案与本地化出口
- `Tests/`: 单测、集成测试、AI 测试

## 2.1 AI 操作安全边界

- 修改前先检查仓库状态并阅读相关文件，未读文件不得直接覆盖。
- 现有未提交改动属于用户，禁止修改无关文件。
- 未经明确授权，不得 commit、push、merge、发布、部署或修改生产基础设施。
- 数据库、持久化数据和不可逆迁移必须先有备份、回滚方案和迁移测试。
- 不得为了通过检查而关闭测试、lint、分支保护或安全规则。
- 修改后运行约定检查、`swift test` 和最小消费示例测试；未执行项必须明确说明。
- secret 不得进入 prompt、日志、fixture、截图、telemetry 或版本库。

## 3. 单文件单主类型规则

- 每个 Swift 文件只允许一个主类型：`class`、`struct`、`enum`、`actor`、`protocol` 之一。
- 允许同文件出现该主类型的 `extension`。
- 允许同文件出现 `#if DEBUG` 预览。
- 禁止多个并列主类型混在一个文件里。
- 禁止把多个 View、多个 ViewModel、多个 Service 混在一个文件里。
- 如果页面过大，拆成多个独立文件，每个文件仍只承载一个主类型。

## 4. 复用优先规则

新增 UI 或功能前，必须按顺序执行：

1. 先查本文件中的共享组件登记区。
2. 再查 `docs/component-registry.md`。
3. 若已有能力能覆盖大部分需求，先扩展已有共享组件或共享服务。
4. 只有当职责边界明显不同，才允许新建共享组件。

以下内容不得在多个页面各自实现一次：

- 通用按钮、卡片、输入框、空状态、列表项、sheet 容器、筛选器
- 通用权限流程、导出流程、缓存逻辑、格式化逻辑、AI 请求封装
- 通用状态展示，如 loading、error、empty、success

## 5. AI-First 约束

- 页面和 ViewModel 不允许直接拼接 prompt。
- 所有 AI 调用统一经 `Shared/AI/` 抽象层发起。
- 所有结构化 AI 输出必须定义 schema、decoder 和 fallback。
- 所有 AI 调用必须有 timeout、retry、cancellation。
- 所有 AI 请求上下文必须显式声明 telemetry、cache policy、调用来源和 user-safe metadata。
- prompt、schema、fixture 必须可测试、可审计。
- 敏感信息默认不得进入 prompt。
- 能本地完成的任务优先本地，不把 AI 当万能逻辑层。

## 6. SwiftUI 与并发约束

- 所有驱动 UI 的 ViewModel 默认标注 `@MainActor`，除非有明确理由放到后台 actor。
- 跨并发边界传递的共享模型、AI 上下文和值类型优先实现 `Sendable`。
- 页面里的异步任务必须可取消，禁止在 View 中保留失控的长生命周期任务。
- 不允许在 `body` 中创建重量对象、发起网络请求或执行副作用。
- Feature 里的状态更新必须通过明确的方法入口完成，避免在多个 View 中直接改共享状态。
- 若使用 Observation，保持“谁创建谁持有，谁注入谁声明”的边界，不混用隐式全局状态。

## 7. 本地化与文案约束

- 用户可见文案必须统一从 `Localization/` 或 `Localizable.xcstrings` 出口获取。
- `templates/Features/`、`App/`、`Shared/DesignSystem/` 中禁止新增面向用户的硬编码英文或中文文案。
- 调试日志、测试断言和开发者注释不属于用户可见文案。
- 共享组件接受的是语义化文案输入，不直接内嵌业务文案。

## 8. 新共享组件创建流程

创建新的共享组件前，必须确认：

- 现有共享组件无法合理扩展
- 新组件职责清晰，不是某个页面的临时私有视图
- 已定义组件输入、输出、扩展方向和使用边界

创建新的共享组件后，必须同步完成：

1. 在 `Shared/DesignSystem/Components/` 或对应共享层落文件
2. 为组件补上 Preview 或示例使用代码
3. 补上最少一条测试或快照策略说明
4. 更新本文件中的共享组件登记区
5. 更新 `docs/component-registry.md`

## 9. 文件命名规则

- View: `FeatureNameView.swift`
- ViewModel: `FeatureNameViewModel.swift`
- Service: `FeatureNameService.swift`
- Reusable Component: `DSComponentName.swift` 或项目前缀组件名
- AI capability: `TaskNameCapability.swift`
- Prompt builder: `TaskNamePromptBuilder.swift`
- Schema: `TaskNameSchema.swift`

## 10. 工程基线与 CI

- 仓库必须提供最少一套本地规范配置：`SwiftLint`、`SwiftFormat` 或等价脚本。
- 仓库必须提供最少一条 CI 流程，运行约定检查、构建和测试。
- CI 失败视为规则未落地，不能靠人工口头兜底。
- 新 starter 模板必须先通过自己的检查脚本，再作为示例提供给业务项目。
- 修改 public starter API 时必须同步更新并测试 `Examples/StarterExample`，不得留下失效示例。
- 严格并发级别、最低 iOS 版本、Swift 版本、Debug/Release 差异必须在工程配置或文档中可见。

## 11. 禁止事项

- 禁止在业务页面直接访问底层 provider SDK
- 禁止新增重复通用控件而不先扩展已有控件
- 禁止新增共享组件后不登记
- 禁止为了图快把多个主类型塞进同一个文件
- 禁止把页面私有逻辑伪装成共享层能力
- 禁止在 Feature 之间直接引用彼此实现
- 禁止在 `Shared/` 目录反向依赖具体 Feature 类型
- 禁止把用户可见文案直接写进页面或共享组件
- 禁止只写规范不提供脚本或 CI 落地

## 12. Shared Component Registry

新增共享组件后必须登记。格式固定如下：

| Name | Type | Layer | Purpose | Inputs | Outputs | Used By | Extend Instead Of Rebuild | Last Updated |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| DSPrimaryButton | View | Shared/DesignSystem | 主操作按钮，统一 loading、disabled、icon、size | `title`, `icon`, `isLoading`, `isEnabled`, `size` | `action` | Login, Onboarding, Settings | 需要主按钮时先扩展它，不要新建第二套 Primary Button | 2026-03-27 |
| DSEmptyStateView | View | Shared/DesignSystem | 统一空状态展示 | `icon`, `title`, `message`, `actionTitle` | `action` | Favorites, Search, Projects | 页面空状态先扩展它 | 2026-03-27 |
| AICapability | AI Protocol | Shared/AI | 统一 AI 任务能力接口，要求所有具体能力走相同抽象 | `Input`, `AIRequestContext` | `Output` | Shared AI Layer | 定义新 AI 任务时优先实现它，不要跳过 capability 层 | 2026-03-27 |
| AISummarizationCapability | AI Capability | Shared/AI | 统一摘要型 AI 任务入口 | `AIRequestContext`, `PromptInput` | `StructuredSummary` | Search, Notes, Insights | 有摘要诉求先扩展能力，不要绕过 AI 层 | 2026-03-27 |

## 13. 开发前检查清单

- 是否已运行 `scripts/init-project-skills.sh` 检查技能状态
- 推荐 skills 是否已就绪
- 是否查过共享组件登记区
- 是否确认新代码放在正确层级
- 是否遵守单文件单主类型
- 是否避免业务层直接依赖 AI provider
- 是否避免新增硬编码用户文案
- 是否保证 ViewModel 的 UI 更新在 `@MainActor`
- 是否为新规则接入脚本或 CI
- 若新增共享组件，是否已同步登记

## 14. Recommended Skills

初始化项目时，建议优先确保以下 skills 可用：

| Skill | Why |
| --- | --- |
| `openai-docs` | 查询官方 OpenAI 文档，避免 AI 产品接入靠过期记忆 |
| `playwright` | 做 WebView、网页控制台、管理后台或自动化 UI 验证 |
| `screenshot` | 做桌面或窗口截图验证 |
| `pdf` | 处理 PDF 规格、导出物、设计稿附件 |
| `documents` | 处理 `.docx` 文档和交付材料 |

可选但强烈建议在本地额外具备：

| Skill | Why |
| --- | --- |
| `swiftui-pro` | 规范 SwiftUI 视图、状态和现代 API 使用 |
| `sosumi` | 查询 Apple API 和 HIG 文档 |

规则如下：

- 初始化项目时先运行 `scripts/init-project-skills.sh`，默认仅检查
- 需要安装缺失的 required curated skills 时，显式运行 `scripts/init-project-skills.sh --install`
- 脚本会检查 `$CODEX_HOME/skills` 和 `$CODEX_HOME/skills/.system`
- 不带参数时不修改本机技能目录
- `--install` 只安装缺失的 required curated skills
- 非官方 curated 的本地自定义 skills 只做提示，不做路径猜测或强装
