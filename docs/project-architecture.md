# Project Architecture

## 目标

用最少的目录层级把职责切清楚，让 SwiftUI、共享组件、平台桥接和 AI 能力都能长期演进。

## 推荐目录结构

```text
.
├── App/
├── Features/
│   ├── ExampleFeature/
│   │   ├── Views/
│   │   ├── ViewModels/
│   │   ├── Services/
│   │   ├── Components/
│   │   └── Models/
├── Shared/
│   ├── AI/
│   ├── Core/
│   ├── DesignSystem/
│   │   ├── Components/
│   │   ├── Modifiers/
│   │   └── Tokens/
│   └── Platform/
├── Localization/
├── Resources/
└── Tests/
    ├── UnitTests/
    ├── IntegrationTests/
    └── AITests/
```

## 各层职责

### App

只负责：

- App 入口
- Scene 配置
- 全局依赖注入
- 根路由装配
- 环境切换

不得承担业务逻辑、AI prompt 拼接或通用 UI 实现。

### Features

每个 Feature 只放该业务模块自己的内容：

- `Views/`: 页面和该页面的私有视图
- `ViewModels/`: 页面状态编排
- `Services/`: 该 Feature 的业务服务
- `Components/`: 仅该 Feature 私有的可复用子组件
- `Models/`: Feature 私有模型

当某个组件、服务、模型开始被两个 Feature 使用时，应迁移到 `Shared/`。

### Shared/DesignSystem

用于沉淀全项目统一 UI 能力：

- Buttons
- Cards
- Input fields
- Empty states
- Loading states
- Token definitions
- Standard modifiers
- Typography / spacing / color / radius / elevation

### Shared/Core

用于沉淀非 UI 的共享能力：

- Domain models
- Error models
- Logging
- Persistence facades
- Formatting helpers
- Common services

### Shared/AI

用于统一管理 AI 任务：

- Provider abstraction
- Prompt builders
- Response schemas
- Decoders
- Retry / timeout / cancellation policy
- Cache
- Telemetry
- Fixtures for tests

### Shared/Platform

用于封装系统能力：

- Permissions
- Camera
- Share sheet
- Clipboard
- File import/export
- System settings jump

### Localization

所有文案从统一出口获取，不允许页面里硬编码用户可见文本。
推荐为 starter 项目同时提供 `Localization/` 包装层和 `Localizable.xcstrings` 资源模板。

## 依赖方向

必须保持以下依赖方向：

- `App -> Features / Shared`
- `Features -> Shared`
- `Shared` 内部低层可被高层依赖
- `Features` 之间不得直接耦合实现
- `Shared/AI` 不得反向依赖具体 Feature
- `Shared/` 不得 import 或引用具体 `Features/` 下的类型

## 文件拆分原则

- 一个文件一个主类型
- 页面拆大时，用独立文件承载子视图，不使用多个并列主类型堆叠在同一个文件
- 复用边界清晰后，优先迁移到 `Shared/`
