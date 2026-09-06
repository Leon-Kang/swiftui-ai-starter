# Design System Rules

## 目标

共享 UI 必须先统一设计语言，再进入业务页面。任何新页面都应该优先使用共享设计系统，而不是从页面内部临时拼出一套新视觉规则。

## 共享层必须包含

- 色彩 token
- 字体 token
- 间距 token
- 圆角 token
- 阴影或层级 token
- 标准按钮
- 标准卡片
- 标准输入组件
- 标准空状态
- 标准 loading / error / success 状态

## 组件分层

- `Shared/DesignSystem/Components/`: 跨 Feature 复用组件
- `Features/<Feature>/Components/`: 只在该 Feature 内复用的私有组件

只要组件开始被第二个 Feature 使用，就应该迁移到共享层。

## 样式规则

- 不允许在业务页面大面积写 magic numbers
- 间距、字体、圆角、颜色都优先取 token
- 同类交互要复用统一组件，而不是只复用颜色
- 复杂样式通过 modifier 或 style 抽象，不要在页面里复制粘贴

## 组件设计原则

- 输入清晰
- 输出清晰
- 状态有限且可枚举
- 避免把业务逻辑塞进纯 UI 组件
- 可扩展优先于一次性定制
