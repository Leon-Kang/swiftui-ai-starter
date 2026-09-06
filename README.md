# SwiftUI AI Starter

[简体中文](README.zh-CN.md)

An opinionated, reusable foundation for SwiftUI projects built by humans and AI coding agents.

The starter keeps product code private while making the engineering contract explicit: architecture boundaries, reusable UI, structured AI capabilities, localization, concurrency, tests, and CI all start with enforceable rules.

## What is included

- `AGENTS.md` — the shared operating contract for developers and coding agents
- `docs/` — architecture, design-system, AI, localization, and workflow guidance
- `templates/` — reusable SwiftUI, service, platform, localization, and AI building blocks
- `scripts/` — executable convention and component-registry checks
- `Examples/StarterExample/` — a minimal Swift package that demonstrates the structure
- `.github/workflows/` — CI for the rules and the example package

## Why use it

- Start new SwiftUI projects with clear dependency and ownership boundaries.
- Give coding agents concrete rules that can be checked instead of relying on prompts alone.
- Prefer shared capabilities over duplicated feature-level implementations.
- Keep AI calls structured, cancellable, testable, and safe for user data.
- Make localization and Swift concurrency part of the baseline rather than later cleanup.

## Quick start

1. Select **Use this template** on GitHub, or copy the repository into a new project.
2. Read `AGENTS.md` before adding product code.
3. Audit recommended local skills. Installation remains opt-in:

   ```bash
   bash scripts/init-project-skills.sh
   bash scripts/init-project-skills.sh --install
   ```

4. Run the starter checks:

   ```bash
   bash scripts/check-project-conventions.sh .
   bash scripts/check-component-registry.sh .
   ```

5. Open the example package in Xcode or verify it from the command line:

   ```bash
   swift test --package-path Examples/StarterExample
   ```

6. Adapt the files under `templates/` to your app and register new shared components in both `AGENTS.md` and `docs/component-registry.md`.

## Principles

- One primary type per Swift file.
- Feature modules depend on shared abstractions, never on other feature implementations.
- UI-driving state is isolated to the main actor.
- User-facing copy goes through localization resources.
- AI providers remain behind capability, schema, timeout, retry, cancellation, telemetry, cache, and fallback boundaries.
- Rules that matter are backed by scripts or CI.

## Scope

This repository is an engineering starter, not a complete application generator. It intentionally contains no product branding, backend credentials, analytics setup, monetization code, or provider-specific secrets.

## Related project

After a project is initialized, [issue-to-pr](https://github.com/Leon-Kang/issue-to-pr) provides a human-gated workflow from an issue to a tested, reviewed pull request.

## License

Released under the [MIT License](LICENSE).
