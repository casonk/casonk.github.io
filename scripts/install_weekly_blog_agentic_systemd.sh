#!/usr/bin/env bash
# install_weekly_blog_agentic_systemd.sh — render and enable the weekly blog
# authoring timer via the shared clockwork scheduler utility.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATE_PATH="${REPO_ROOT}/config/clockwork/weekly-blog-agentic.toml.template"
UNIT_TARGET_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"
CLOCKWORK_REPO_DEFAULT="${REPO_ROOT}/../../util-repos/clockwork"
CLOCKWORK_REPO="${CLOCKWORK_REPO:-${CLOCKWORK_REPO_DEFAULT}}"
RENDER_ONLY=0

usage() {
  cat <<EOF
Usage: install_weekly_blog_agentic_systemd.sh [options]

Render the weekly casonk.github.io blog timer through clockwork and enable it
for the current user by default.

Options:
  --render-only         Write the unit files only; skip daemon-reload/enable.
  --unit-dir DIR        Override the target user unit directory.
  --clockwork-repo PATH Override the sibling clockwork repo path fallback.
  --help                Show this help text.
EOF
}

fail() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

ensure_user_systemd_env() {
  local runtime_path=""

  if [[ -z "${XDG_RUNTIME_DIR:-}" ]] && command -v loginctl >/dev/null 2>&1; then
    runtime_path="$(loginctl show-user "$(id -un)" -p RuntimePath --value 2>/dev/null || true)"
    if [[ -n "${runtime_path}" ]]; then
      export XDG_RUNTIME_DIR="${runtime_path}"
    fi
  fi

  if [[ -n "${XDG_RUNTIME_DIR:-}" ]] && [[ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ]] \
    && [[ -S "${XDG_RUNTIME_DIR}/bus" ]]; then
    export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"
  fi
}

escape_sed_replacement() {
  printf '%s' "$1" | sed 's/[&|]/\\&/g'
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --render-only)
      RENDER_ONLY=1
      shift
      ;;
    --unit-dir)
      UNIT_TARGET_DIR="$2"
      shift 2
      ;;
    --clockwork-repo)
      CLOCKWORK_REPO="$2"
      shift 2
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      fail "unknown argument: $1"
      ;;
  esac
done

command -v python3 >/dev/null 2>&1 || fail "python3 not found"
[[ -f "${TEMPLATE_PATH}" ]] || fail "missing template: ${TEMPLATE_PATH}"

if command -v clockwork >/dev/null 2>&1; then
  CLOCKWORK_CMD=(clockwork)
else
  [[ -d "${CLOCKWORK_REPO}/src/clockwork" ]] || fail "clockwork not found at ${CLOCKWORK_REPO}"
  export PYTHONPATH="${CLOCKWORK_REPO}/src${PYTHONPATH:+:${PYTHONPATH}}"
  CLOCKWORK_CMD=(python3 -m clockwork)
fi

TMP_MANIFEST="$(mktemp)"
trap 'rm -f "${TMP_MANIFEST}"' EXIT

sed \
  -e "s|__REPO_ROOT__|$(escape_sed_replacement "${REPO_ROOT}")|g" \
  "${TEMPLATE_PATH}" > "${TMP_MANIFEST}"

"${CLOCKWORK_CMD[@]}" install \
  --manifest "${TMP_MANIFEST}" \
  --target systemd-user \
  --unit-dir "${UNIT_TARGET_DIR}"

if (( RENDER_ONLY == 1 )); then
  exit 0
fi

ensure_user_systemd_env

systemctl --user daemon-reload
systemctl --user enable --now weekly-blog-agentic.timer
systemctl --user list-timers weekly-blog-agentic.timer
