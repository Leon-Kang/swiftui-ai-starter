# Recommended Skills

## 目标

这份清单定义 starter kit 建议优先具备的 Codex skills，以及哪些支持显式安装，哪些只做本地提示。

## 检查与显式安装

以下 skills 已验证可以通过官方 `skill-installer` 走 `openai/skills` curated 列表安装：

| Skill | Purpose | Install Mode |
| --- | --- | --- |
| `openai-docs` | OpenAI 文档检索 | built-in / already available |
| `playwright` | 浏览器自动化与 UI 验证 | install with `--install` |
| `screenshot` | 桌面截图与视觉核对 | install with `--install` |
| `pdf` | PDF 读取与生成 | advisory only |
| `documents` | `.docx` 读取与编辑 | advisory only |

## 本地可选增强

以下 skills 很适合 iOS SwiftUI AI-first 项目，但不在 starter kit 中做路径猜测安装：

| Skill | Purpose | Install Mode |
| --- | --- | --- |
| `swiftui-pro` | SwiftUI 结构、状态管理、现代 API 规范 | local-only advisory |
| `sosumi` | Apple API 文档和 HIG 查询 | local-only advisory |

## 初始化规则

初始化项目时执行：

```bash
./scripts/init-project-skills.sh
```

确认需要安装缺失的 required curated skills 后执行：

```bash
./scripts/init-project-skills.sh --install
```

脚本行为：

1. 检查 `$CODEX_HOME/skills` 与 `$CODEX_HOME/skills/.system`
2. 默认仅报告缺失项，不修改本机技能目录
3. 传入 `--install` 时，只安装缺失的 required curated skills
4. 对缺失的 optional 与本地增强 skills 给出提示
5. 输出最终状态摘要
