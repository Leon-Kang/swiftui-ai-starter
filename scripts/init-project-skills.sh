#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STARTER_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CONFIG_FILE="$STARTER_ROOT/config/recommended-skills.json"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
USER_SKILLS_DIR="$CODEX_HOME/skills"
SYSTEM_SKILLS_DIR="$CODEX_HOME/skills/.system"
INSTALLER_SCRIPT="$SYSTEM_SKILLS_DIR/skill-installer/scripts/install-skill-from-github.py"
INSTALL_MISSING=0

if [[ $# -gt 1 ]]; then
  echo "usage: $0 [--install]"
  exit 2
fi

if [[ $# -eq 1 ]]; then
  if [[ "$1" != "--install" ]]; then
    echo "usage: $0 [--install]"
    exit 2
  fi
  INSTALL_MISSING=1
fi

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "error: missing config file at $CONFIG_FILE"
  exit 1
fi

if [[ ! -d "$USER_SKILLS_DIR" ]]; then
  echo "error: missing Codex skills directory at $USER_SKILLS_DIR"
  exit 1
fi

if [[ "$INSTALL_MISSING" -eq 1 && ! -f "$INSTALLER_SCRIPT" ]]; then
  echo "error: missing skill installer at $INSTALLER_SCRIPT"
  exit 1
fi

python3 - "$CONFIG_FILE" "$USER_SKILLS_DIR" "$SYSTEM_SKILLS_DIR" "$INSTALLER_SCRIPT" "$INSTALL_MISSING" <<'PY'
import json
import os
import subprocess
import sys

config_path, user_skills_dir, system_skills_dir, installer_script, install_missing_value = sys.argv[1:6]
install_missing = install_missing_value == "1"

with open(config_path, "r", encoding="utf-8") as handle:
    skills = json.load(handle)

installed = []
already_present = []
manual_missing = []
installable_missing = []
failed = []

def skill_exists(name: str) -> bool:
    return os.path.isdir(os.path.join(user_skills_dir, name)) or os.path.isdir(os.path.join(system_skills_dir, name))

for item in skills:
    name = item["name"]
    mode = item["install_mode"]
    category = item.get("category", "optional")
    reason = item.get("reason", "")

    if skill_exists(name):
        already_present.append((name, reason))
        continue

    if mode == "system":
        manual_missing.append((name, "expected as built-in/system skill but not found"))
        continue

    if mode == "manual":
        manual_missing.append((name, reason))
        continue

    if mode == "openai-curated":
        if category != "required":
            manual_missing.append((name, reason))
            continue

        if not install_missing:
            installable_missing.append((name, reason))
            continue

        command = [
            "python3",
            installer_script,
            "--repo",
            item["repo"],
            "--path",
            item["path"],
        ]
        result = subprocess.run(command, capture_output=True, text=True)
        if result.returncode == 0 and skill_exists(name):
            installed.append((name, reason))
        else:
            failed.append((name, result.stderr.strip() or result.stdout.strip() or "unknown install error"))
        continue

    failed.append((name, f"unsupported install mode: {mode}"))

print("Recommended skills bootstrap summary")
print("")

if already_present:
    print("Already available:")
    for name, reason in already_present:
        print(f"- {name}: {reason}")
    print("")

if installed:
    print("Installed now:")
    for name, reason in installed:
        print(f"- {name}: {reason}")
    print("")

if installable_missing:
    print("Available to install with --install:")
    for name, reason in installable_missing:
        print(f"- {name}: {reason}")
    print("")

if manual_missing:
    print("Manual follow-up:")
    for name, reason in manual_missing:
        print(f"- {name}: {reason}")
    print("")

if failed:
    print("Install failures:")
    for name, error in failed:
        print(f"- {name}: {error}")
    print("")
    sys.exit(1)
PY
