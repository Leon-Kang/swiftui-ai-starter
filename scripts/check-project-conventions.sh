#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${1:-.}"
STATUS=0
HAS_RG=0

if command -v rg >/dev/null 2>&1; then
  HAS_RG=1
fi

search_matches() {
  local pattern="$1"
  local file="$2"

  if [[ "$HAS_RG" -eq 1 ]]; then
    rg -n "$pattern" "$file" || true
  else
    grep -En "$pattern" "$file" || true
  fi
}

search_quiet() {
  local pattern="$1"
  local file="$2"

  if [[ "$HAS_RG" -eq 1 ]]; then
    rg -q "$pattern" "$file"
  else
    grep -Eq "$pattern" "$file"
  fi
}

search_swift_tree() {
  local pattern="$1"
  local root="$2"

  if [[ "$HAS_RG" -eq 1 ]]; then
    rg -n "$pattern" "$root" --glob '*.swift' || true
    return
  fi

  while IFS= read -r file; do
    grep -En "$pattern" "$file" || true
  done < <(find "$root" -type f -name '*.swift' | sort)
}

check_single_primary_type() {
  while IFS= read -r file; do
    [[ "$file" == *"/Pods/"* ]] && continue
    [[ "$file" == *"/.build/"* ]] && continue
    [[ "$file" == *"/Carthage/"* ]] && continue

    local count
    count=$(search_matches '^[[:space:]]*(final[[:space:]]+)?(class|struct|enum|actor|protocol)[[:space:]]+[A-Za-z_][A-Za-z0-9_]*' "$file" | wc -l | tr -d ' ')
    if [[ "$count" -gt 1 ]]; then
      echo "error: multiple primary types in $file"
      STATUS=1
    fi
  done < <(find "$ROOT_DIR" -type f -name '*.swift' | sort)
}

warn_duplicate_design_system_components() {
  if [[ ! -d "$ROOT_DIR/Shared/DesignSystem/Components" || ! -d "$ROOT_DIR/Features" ]]; then
    return
  fi

  while IFS= read -r component; do
    local base
    base=$(basename "$component" .swift)
    local duplicates
    duplicates=$(find "$ROOT_DIR/Features" -type f -name "$base.swift" | wc -l | tr -d ' ')
    if [[ "$duplicates" -gt 0 ]]; then
      echo "warning: feature-local duplicate of shared component '$base' detected"
    fi
  done < <(find "$ROOT_DIR/Shared/DesignSystem/Components" -type f -name '*.swift' | sort)
}

check_hardcoded_user_facing_strings() {
  local scan_roots=(
    "$ROOT_DIR/templates/App"
    "$ROOT_DIR/templates/Features"
    "$ROOT_DIR/templates/Shared/DesignSystem"
  )
  local direct_view_pattern='(Text|Button|Label|navigationTitle|navigationSubtitle)\s*\(\s*"[^"]*[A-Za-z][^"]*"'
  local named_argument_pattern='\b(title|message|actionTitle)\s*:\s*"[^"]*[A-Za-z][^"]*"'

  for root in "${scan_roots[@]}"; do
    [[ -d "$root" ]] || continue

    while IFS= read -r match; do
      echo "error: hardcoded user-facing string detected: $match"
      STATUS=1
    done < <(search_swift_tree "$direct_view_pattern|$named_argument_pattern" "$root")
  done
}

check_viewmodels_main_actor() {
  local viewmodel_root="$ROOT_DIR/templates/Features"
  [[ -d "$viewmodel_root" ]] || return

  while IFS= read -r file; do
    if search_quiet 'ObservableObject' "$file" && ! search_quiet '@MainActor' "$file"; then
      echo "error: ObservableObject view model must be annotated with @MainActor: $file"
      STATUS=1
    fi
  done < <(find "$viewmodel_root" -path '*/ViewModels/*.swift' -type f | sort)
}

check_ai_request_context_contract() {
  local file="$ROOT_DIR/templates/Shared/AI/AIRequestContext.swift"
  [[ -f "$file" ]] || return

  local required_fields=(feature timeout allowsRetry cancellationBehavior telemetry cachePolicy traceID userMetadata)
  local field
  for field in "${required_fields[@]}"; do
    if ! search_quiet "\\b${field}\\b" "$file"; then
      echo "error: AIRequestContext is missing required field '${field}'"
      STATUS=1
    fi
  done
}

check_localization_resources_exist() {
  local localization_dir="$ROOT_DIR/templates/Localization"
  [[ -d "$localization_dir" ]] || return

  if ! find "$localization_dir" -type f \( -name '*.xcstrings' -o -name 'Localizable.strings' \) | grep -q .; then
    echo "error: Localization template must include Localizable.xcstrings or Localizable.strings"
    STATUS=1
  fi
}

check_engineering_baseline_files() {
  if [[ ! -f "$ROOT_DIR/.swiftlint.yml" && ! -f "$ROOT_DIR/.swiftformat" ]]; then
    echo "error: missing formatting/lint baseline (.swiftlint.yml or .swiftformat)"
    STATUS=1
  fi

  if ! find "$ROOT_DIR/.github/workflows" -type f \( -name '*.yml' -o -name '*.yaml' \) 2>/dev/null | grep -q .; then
    echo "error: missing CI workflow under .github/workflows"
    STATUS=1
  fi
}

check_single_primary_type
warn_duplicate_design_system_components
check_hardcoded_user_facing_strings
check_viewmodels_main_actor
check_ai_request_context_contract
check_localization_resources_exist
check_engineering_baseline_files

exit "$STATUS"
