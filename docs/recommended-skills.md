# Recommended Skills

## 目标

这份清单定义 starter kit 建议优先具备的 Codex skills，以及哪些可以自动安装，哪些只做本地提示。

## 自动检查并安装

以下 skills 已验证可以通过官方 `skill-installer` 走 `openai/skills` curated 列表自动安装：

| Skill | Purpose | Install Mode |
| --- | --- | --- |
| `openai-docs` | OpenAI 文档检索 | built-in / already available |
| `playwright` | 浏览器自动化与 UI 验证 | auto-install |
| `screenshot` | 桌面截图与视觉核对 | auto-install |
| `pdf` | PDF 读取与生成 | auto-install |
| `doc` | `.docx` 读取与编辑 | auto-install |

## 本地可选增强

以下 skills 很适合 iOS SwiftUI AI-first 项目，但不在 starter kit 中做路径猜测安装：

| Skill | Purpose | Install Mode |
| --- | --- | --- |
| `swiftui-expert-skill` | SwiftUI 结构、状态管理、现代 API 规范 | local-only advisory |
| `sosumi` | Apple API 文档和 HIG 查询 | local-only advisory |

## 初始化规则

初始化项目时执行：

```bash
./scripts/init-project-skills.sh
```

脚本行为：

1. 检查 `$CODEX_HOME/skills` 与 `$CODEX_HOME/skills/.system`
2. 对缺失的 curated skills 自动安装
3. 对缺失的本地增强 skills 给出提示
4. 输出最终状态摘要
