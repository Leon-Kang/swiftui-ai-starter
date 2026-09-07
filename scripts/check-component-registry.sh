#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${1:-.}"
AGENTS_FILE="$ROOT_DIR/AGENTS.md"
REGISTRY_FILE="$ROOT_DIR/docs/component-registry.md"
STATUS=0
HAS_RG=0

if [[ ! -f "$AGENTS_FILE" ]]; then
  echo "error: missing $AGENTS_FILE"
  exit 1
fi

if [[ ! -f "$REGISTRY_FILE" ]]; then
  echo "error: missing $REGISTRY_FILE"
  exit 1
fi

if command -v rg >/dev/null 2>&1; then
  HAS_RG=1
fi

search_quiet() {
  local pattern="$1"
  local file="$2"

  if [[ "$HAS_RG" -eq 1 ]]; then
    rg -q "$pattern" "$file"
  else
    grep -Eq "$pattern" "$file"
  fi
}

check_registered() {
  local path="$1"
  local name
  name=$(basename "$path" .swift)

  if ! search_quiet "\b${name}\b" "$AGENTS_FILE"; then
    echo "error: shared artifact '$name' is not registered in AGENTS.md"
    STATUS=1
  fi

  if ! search_quiet "\b${name}\b" "$REGISTRY_FILE"; then
    echo "error: shared artifact '$name' is not registered in docs/component-registry.md"
    STATUS=1
  fi
}

DESIGN_SYSTEM_ROOT="$ROOT_DIR/templates/Shared/DesignSystem/Components"
[[ -d "$DESIGN_SYSTEM_ROOT" ]] || DESIGN_SYSTEM_ROOT="$ROOT_DIR/Shared/DesignSystem/Components"
if [[ -d "$DESIGN_SYSTEM_ROOT" ]]; then
  while IFS= read -r component; do
    check_registered "$component"
  done < <(find "$DESIGN_SYSTEM_ROOT" -type f -name '*.swift' | sort)
fi

AI_ROOT="$ROOT_DIR/templates/Shared/AI"
[[ -d "$AI_ROOT" ]] || AI_ROOT="$ROOT_DIR/Shared/AI"
if [[ -d "$AI_ROOT" ]]; then
  while IFS= read -r capability; do
    check_registered "$capability"
  done < <(find "$AI_ROOT" -type f -name '*Capability.swift' | sort)
fi

exit "$STATUS"
