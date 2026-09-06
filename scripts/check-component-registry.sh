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

while IFS= read -r component; do
  check_registered "$component"
done < <(find "$ROOT_DIR/templates/Shared/DesignSystem/Components" -type f -name '*.swift' | sort)

while IFS= read -r capability; do
  check_registered "$capability"
done < <(find "$ROOT_DIR/templates/Shared/AI" -type f -name '*Capability.swift' | sort)

exit "$STATUS"
