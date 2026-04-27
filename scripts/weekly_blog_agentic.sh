#!/usr/bin/env bash
# weekly_blog_agentic.sh — write and optionally publish a weekly Codex-authored
# blog post for casonk.github.io from a temporary clean git worktree.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PORTFOLIO_ROOT_DEFAULT="$(cd "${REPO_ROOT}/../.." && pwd)"
TRACTION_CONTROL_REPO_DEFAULT="${PORTFOLIO_ROOT_DEFAULT}/util-repos/traction-control"
PROMPT_FILE_DEFAULT="${REPO_ROOT}/config/prompts/weekly-blog-agentic.md"
LOG_DIR_DEFAULT="${HOME}/.local/share/weekly-blog-agentic"

PORTFOLIO_ROOT="${PORTFOLIO_ROOT:-${PORTFOLIO_ROOT_DEFAULT}}"
TRACTION_CONTROL_REPO="${TRACTION_CONTROL_REPO:-${TRACTION_CONTROL_REPO_DEFAULT}}"
PROMPT_FILE="${WEEKLY_BLOG_AGENTIC_PROMPT_FILE:-${PROMPT_FILE_DEFAULT}}"
LOG_DIR="${LOG_DIR:-${LOG_DIR_DEFAULT}}"
MODEL_REQUESTED="${WEEKLY_BLOG_AGENTIC_MODEL:-}"
PUSH_ENABLED="${WEEKLY_BLOG_AGENTIC_PUSH:-1}"
KEEP_WORKTREE="${WEEKLY_BLOG_AGENTIC_KEEP_WORKTREE:-0}"
BRANCH_REQUESTED="${WEEKLY_BLOG_AGENTIC_BRANCH:-}"

usage() {
  cat <<EOF
Usage: weekly_blog_agentic.sh [options]

Create a weekly Codex-authored blog post from a temporary clean worktree,
validate the result, and optionally push it to the tracked remote branch.

Options:
  --branch NAME          Override the target branch. Default: origin HEAD branch.
  --log-dir DIR          Override the run-log directory.
  --model MODEL          Override the Codex model used for authoring.
  --prompt-file PATH     Override the tracked prompt file.
  --no-push              Commit locally in the temporary worktree but skip git push.
  --keep-worktree        Keep the temporary worktree after success.
  --help                 Show this help text.

Environment overrides:
  WEEKLY_BLOG_AGENTIC_BRANCH
  WEEKLY_BLOG_AGENTIC_MODEL
  WEEKLY_BLOG_AGENTIC_PROMPT_FILE
  WEEKLY_BLOG_AGENTIC_PUSH   (1 or 0)
  WEEKLY_BLOG_AGENTIC_KEEP_WORKTREE (1 or 0)
  LOG_DIR
  TRACTION_CONTROL_REPO
  PORTFOLIO_ROOT
EOF
}

fail() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

log() {
  printf '[%s] %s\n' "$(date '+%H:%M:%S')" "$*" | tee -a "${LOG_FILE}"
}

trim_text() {
  printf '%s' "$1" | tr '\r\n\t' '   ' | sed 's/[[:space:]]\+/ /g; s/^ //; s/ $//'
}

default_branch() {
  local default_ref=""

  default_ref="$(git -C "${REPO_ROOT}" symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null || true)"
  if [[ -n "${default_ref}" ]]; then
    printf '%s\n' "${default_ref#origin/}"
    return 0
  fi

  if git -C "${REPO_ROOT}" show-ref --verify --quiet refs/remotes/origin/main \
    || git -C "${REPO_ROOT}" show-ref --verify --quiet refs/heads/main; then
    printf 'main\n'
    return 0
  fi

  if git -C "${REPO_ROOT}" show-ref --verify --quiet refs/remotes/origin/master \
    || git -C "${REPO_ROOT}" show-ref --verify --quiet refs/heads/master; then
    printf 'master\n'
    return 0
  fi

  return 1
}

run_precommit_until_clean() {
  local attempt=1

  while (( attempt <= 2 )); do
    if pre-commit run --all-files; then
      return 0
    fi
    log "pre-commit pass ${attempt} requested file rewrites; retrying"
    attempt=$(( attempt + 1 ))
  done

  return 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --branch)
      BRANCH_REQUESTED="$2"
      shift 2
      ;;
    --log-dir)
      LOG_DIR="$2"
      shift 2
      ;;
    --model)
      MODEL_REQUESTED="$2"
      shift 2
      ;;
    --prompt-file)
      PROMPT_FILE="$2"
      shift 2
      ;;
    --no-push)
      PUSH_ENABLED=0
      shift
      ;;
    --keep-worktree)
      KEEP_WORKTREE=1
      shift
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

[[ "${PUSH_ENABLED}" =~ ^[01]$ ]] || fail "WEEKLY_BLOG_AGENTIC_PUSH must be 0 or 1"
[[ "${KEEP_WORKTREE}" =~ ^[01]$ ]] || fail "WEEKLY_BLOG_AGENTIC_KEEP_WORKTREE must be 0 or 1"

command -v git >/dev/null 2>&1 || fail "git not found"
command -v codex >/dev/null 2>&1 || fail "codex not found"
command -v bundle >/dev/null 2>&1 || fail "bundle not found"
command -v pre-commit >/dev/null 2>&1 || fail "pre-commit not found"
[[ -f "${PROMPT_FILE}" ]] || fail "missing prompt file: ${PROMPT_FILE}"
[[ -f "${REPO_ROOT}/AGENTS.md" ]] || fail "missing repo AGENTS.md"
[[ -d "${TRACTION_CONTROL_REPO}" ]] || fail "missing traction-control repo: ${TRACTION_CONTROL_REPO}"
[[ -f "${TRACTION_CONTROL_REPO}/scripts/lib/agentic_provider.sh" ]] \
  || fail "missing agentic provider helper under traction-control"

# shellcheck source=/dev/null
source "${TRACTION_CONTROL_REPO}/scripts/lib/agentic_provider.sh"

mkdir -p "${LOG_DIR}"
LOCK_FILE="${LOG_DIR}/weekly-blog-agentic.lock"
exec 9>"${LOCK_FILE}"
if command -v flock >/dev/null 2>&1; then
  flock -n 9 || {
    printf 'info: another weekly_blog_agentic.sh run is already active\n'
    exit 0
  }
fi

TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
TODAY="$(date +%F)"
RUN_DIR="${LOG_DIR}/${TIMESTAMP}"
WORKTREE_DIR="${RUN_DIR}/repo"
LOG_FILE="${RUN_DIR}/run.log"
PROMPT_RUNTIME_FILE="${RUN_DIR}/prompt.txt"
AGENT_OUTPUT_FILE="${RUN_DIR}/agent-output.txt"
LAST_MESSAGE_FILE="${RUN_DIR}/last-message.txt"
LATEST_LOG_LINK="${LOG_DIR}/latest.log"
LATEST_OUTPUT_LINK="${LOG_DIR}/latest-output.txt"
BRANCH=""
REMOVE_WORKTREE_ON_EXIT=0

mkdir -p "${RUN_DIR}"

cleanup() {
  if (( REMOVE_WORKTREE_ON_EXIT == 1 )); then
    git -C "${REPO_ROOT}" worktree remove --force "${WORKTREE_DIR}" >/dev/null 2>&1 || true
  fi
}
trap cleanup EXIT

BRANCH="${BRANCH_REQUESTED:-$(default_branch)}" || fail "unable to determine target branch"

log "=== weekly blog agentic run ==="
log "repo root       : ${REPO_ROOT}"
log "portfolio root  : ${PORTFOLIO_ROOT}"
log "target branch   : ${BRANCH}"
log "prompt file     : ${PROMPT_FILE}"
log "model override  : ${MODEL_REQUESTED:-<default>}"
log "push enabled    : ${PUSH_ENABLED}"
log "run dir         : ${RUN_DIR}"
log ""

if ! agentic_provider_ready codex "${MODEL_REQUESTED}"; then
  fail "codex is not ready for unattended blog generation"
fi

git -C "${REPO_ROOT}" fetch origin
git -C "${REPO_ROOT}" worktree add --detach "${WORKTREE_DIR}" "origin/${BRANCH}" >/dev/null
REMOVE_WORKTREE_ON_EXIT=1

if compgen -G "${WORKTREE_DIR}/_posts/${TODAY}-*.md" >/dev/null; then
  log "skip: a post dated ${TODAY} already exists in the target branch"
  ln -sf "${LOG_FILE}" "${LATEST_LOG_LINK}"
  exit 0
fi

RECENT_COMMITS="$(git -C "${WORKTREE_DIR}" log --since='21 days ago' --oneline --decorate -n 20 || true)"
RECENT_POSTS="$(
  find "${WORKTREE_DIR}/_posts" -maxdepth 1 -type f -name '*.md' | sort | tail -n 5 \
    | xargs -I{} sh -c 'printf "%s\t" "$(basename "{}")"; sed -n "1,20p" "{}" | sed -n "s/^title: //p"' \
    2>/dev/null || true
)"

{
  cat "${PROMPT_FILE}"
  printf '\n'
  printf 'Runtime context:\n'
  printf '%s\n' "- Today is ${TODAY}."
  printf '%s\n' '- Work only inside this repository checkout.'
  printf '%s\n' "- Create a new post dated ${TODAY}."
  printf '%s\n' '- Do not commit or push; the wrapper script handles git after validation.'
  printf '\nRecent commits:\n%s\n' "${RECENT_COMMITS:-<none>}"
  printf '\nRecent post files and titles:\n%s\n' "${RECENT_POSTS:-<none>}"
} > "${PROMPT_RUNTIME_FILE}"

PROMPT_TEXT="$(cat "${PROMPT_RUNTIME_FILE}")"

run_codex() {
  local cmd=(codex exec --full-auto --color never -C "${WORKTREE_DIR}" -o "${LAST_MESSAGE_FILE}")
  if [[ -n "${MODEL_REQUESTED}" ]]; then
    cmd+=(--model "${MODEL_REQUESTED}")
  fi
  printf '%s\n' "${PROMPT_TEXT}" | "${cmd[@]}" -
}

set +e
AGENT_OUTPUT="$(run_codex 2>&1)"
AGENT_STATUS=$?
set -e

printf '%s\n' "${AGENT_OUTPUT}" | tee -a "${LOG_FILE}" > "${AGENT_OUTPUT_FILE}"
if [[ ! -s "${LAST_MESSAGE_FILE}" ]]; then
  cp "${AGENT_OUTPUT_FILE}" "${LAST_MESSAGE_FILE}"
fi

ln -sf "${LOG_FILE}" "${LATEST_LOG_LINK}"
ln -sf "${AGENT_OUTPUT_FILE}" "${LATEST_OUTPUT_LINK}"

if (( AGENT_STATUS != 0 )); then
  log ""
  log "result          : FAILED during Codex authoring (${AGENT_STATUS})"
  log "worktree kept   : ${WORKTREE_DIR}"
  REMOVE_WORKTREE_ON_EXIT=0
  exit "${AGENT_STATUS}"
fi

if ! compgen -G "${WORKTREE_DIR}/_posts/${TODAY}-*.md" >/dev/null; then
  log ""
  log "result          : FAILED — Codex did not create a post dated ${TODAY}"
  log "worktree kept   : ${WORKTREE_DIR}"
  REMOVE_WORKTREE_ON_EXIT=0
  exit 1
fi

if [[ -z "$(git -C "${WORKTREE_DIR}" status --porcelain 2>/dev/null || true)" ]]; then
  log ""
  log "result          : OK — no repo changes were produced"
  exit 0
fi

log ""
log "validation      : pre-commit run --all-files"
if ! (cd "${WORKTREE_DIR}" && run_precommit_until_clean); then
  log "result          : FAILED during pre-commit"
  log "worktree kept   : ${WORKTREE_DIR}"
  REMOVE_WORKTREE_ON_EXIT=0
  exit 1
fi

log "validation      : bundle exec jekyll doctor"
(cd "${WORKTREE_DIR}" && bundle exec jekyll doctor) | tee -a "${LOG_FILE}"

log "validation      : bundle exec jekyll build --config _config.yml,_config.dev.yml"
(cd "${WORKTREE_DIR}" && bundle exec jekyll build --config _config.yml,_config.dev.yml) | tee -a "${LOG_FILE}"

log "git stage       : add changes"
git -C "${WORKTREE_DIR}" add -A

COMMIT_MESSAGE="feat(posts): publish weekly agentic blog for ${TODAY}"
log "git commit      : ${COMMIT_MESSAGE}"
git -C "${WORKTREE_DIR}" commit -m "${COMMIT_MESSAGE}" | tee -a "${LOG_FILE}"

if (( PUSH_ENABLED == 1 )); then
  log "git push        : origin HEAD:${BRANCH}"
  git -C "${WORKTREE_DIR}" push origin "HEAD:${BRANCH}" | tee -a "${LOG_FILE}"
else
  log "git push        : skipped by configuration"
  log "worktree kept   : ${WORKTREE_DIR}"
  REMOVE_WORKTREE_ON_EXIT=0
fi

if (( KEEP_WORKTREE == 1 )); then
  log "worktree kept   : ${WORKTREE_DIR}"
  REMOVE_WORKTREE_ON_EXIT=0
fi

log ""
log "result          : OK"
