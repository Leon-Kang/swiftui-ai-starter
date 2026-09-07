# SwiftUI AI Starter

[English](README.md)

一套面向新项目的 SwiftUI + AI-first 工程规范包。

目标只有三个：

- 让新项目从第一天起就有清晰的目录边界
- 让 AI 和人类开发者遵守同一套复用与拆分规则
- 让共享组件、共享能力、AI 接入和检查脚本形成闭环

## 包含内容

- `AGENTS.md`：新项目开发入口规范
- `docs/`：架构、设计系统、AI-first、组件登记和开发流程文档
- `config/`：starter kit 配置清单，包括推荐技能列表
- `templates/`：目录骨架和 Swift 接口模板
- `scripts/`：约定检查脚本
- `Package.swift`：编译完整模板并运行 AI 策略测试
- `Examples/StarterExample/`：真正依赖 starter runtime 的最小外部消费示例

## 使用方式

1. 在 GitHub 选择 **Use this template**，或复制仓库到新项目。
2. 开始开发前先阅读 `AGENTS.md`。
3. 检查推荐技能。安装操作需要显式确认：

   ```bash
   bash scripts/init-project-skills.sh
   bash scripts/init-project-skills.sh --install
   ```

4. 运行规则检查：

   ```bash
   bash scripts/check-project-conventions.sh .
   bash scripts/check-component-registry.sh .
   swift test
   ```

5. 验证示例项目：

   ```bash
   swift test --package-path Examples/StarterExample
   ```

6. 根据项目需要采用 `templates/`，新增共享组件时同步登记。

模板版本记录在 `starter-version.json`，后续升级先阅读 `docs/upgrading.md`。

## 边界

这是工程起点，不是完整 App 生成器。仓库不包含产品品牌、业务数据、后端凭据、商业化逻辑或 AI provider secret。

项目初始化后，可以使用 [issue-to-pr](https://github.com/Leon-Kang/issue-to-pr) 将 issue 推进为经过测试和审查的 pull request。

## License

使用 [MIT License](LICENSE) 发布。
