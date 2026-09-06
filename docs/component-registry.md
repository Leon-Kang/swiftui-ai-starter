# Component Registry

共享组件、共享服务、共享 AI capability 一律在这里登记。新增后不登记，视为未完成。

## 记录格式

每条记录必须包含以下字段：

- `Name`
- `Type`
- `Layer`
- `Purpose`
- `Inputs`
- `Outputs`
- `Used By`
- `Extend Instead Of Rebuild`
- `Last Updated`

## 示例

### DSPrimaryButton

- `Name`: `DSPrimaryButton`
- `Type`: `View`
- `Layer`: `Shared/DesignSystem/Components`
- `Purpose`: 统一主按钮样式、尺寸、图标和 loading 态
- `Inputs`: `title`, `icon`, `size`, `isLoading`, `isEnabled`
- `Outputs`: `action`
- `Used By`: `Login`, `Onboarding`, `Paywall`
- `Extend Instead Of Rebuild`: 任何主操作按钮需求都优先扩展它
- `Last Updated`: `2026-03-27`

### DSEmptyStateView

- `Name`: `DSEmptyStateView`
- `Type`: `View`
- `Layer`: `Shared/DesignSystem/Components`
- `Purpose`: 统一空状态展示
- `Inputs`: `icon`, `title`, `message`, `actionTitle`
- `Outputs`: `action`
- `Used By`: `Favorites`, `Projects`, `Search`
- `Extend Instead Of Rebuild`: 需要空状态时先扩展，不允许每页自己造一套
- `Last Updated`: `2026-03-27`

### AICapability

- `Name`: `AICapability`
- `Type`: `AI Protocol`
- `Layer`: `Shared/AI`
- `Purpose`: 统一所有 AI 任务能力的执行接口
- `Inputs`: `Input`, `AIRequestContext`
- `Outputs`: `Output`
- `Used By`: `Shared AI Layer`
- `Extend Instead Of Rebuild`: 新 AI 任务先实现该协议，不允许页面绕过 capability 层
- `Last Updated`: `2026-03-27`

### AISummarizationCapability

- `Name`: `AISummarizationCapability`
- `Type`: `AI Capability`
- `Layer`: `Shared/AI`
- `Purpose`: 统一摘要类 AI 任务入口
- `Inputs`: `AIRequestContext`, `SummarizationInput`
- `Outputs`: `StructuredSummary`
- `Used By`: `Search`, `Workspace`, `Notes`
- `Extend Instead Of Rebuild`: 有摘要类任务先扩展 capability，不允许页面直接接 provider
- `Last Updated`: `2026-03-27`
