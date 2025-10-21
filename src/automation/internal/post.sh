#!/usr/bin/env sh

SCRIPT_PATH=$(realpath "$0")
INTERNAL_DIR_PATH=$(dirname "${SCRIPT_PATH}")
AUTOMATION_DIR_PATH=$(dirname "${INTERNAL_DIR_PATH}")
UTILS_DIR_PATH="${AUTOMATION_DIR_PATH}/utils"
SRC_DIR_PATH=$(dirname "${AUTOMATION_DIR_PATH}")
LIB_DIR_PATH="${SRC_DIR_PATH}/lib"

. "${LIB_DIR_PATH}/logging.sh"

commit_changes() {
  set +e
  git diff --quiet --staged
  exit_code=$?
  set -e

  if [ "${exit_code}" -eq 1 ]; then
    log_info "There are changes were made by automation scripts. Committing the changes..."
    git commit -m "chore: bump dependencies to the latest version"
    git push origin main
    ${UTILS_DIR_PATH}/run.sh "get_repo_name" >> "${CHANGED_REPOS_FILE_PATH}"
  else
    log_info "No changes were made by automation scripts"
  fi
}

validate_no_changes_left() {
  set +e
  git diff --quiet
  exit_code=$?
  set -e

  if [ "${exit_code}" -eq 1 ]; then
    changed_files=$(git diff --name-only | awk '{printf "%s%s", sep, $0; sep = ", " } END {print ""}')
    log_warn "There are changes left after running automation scripts: ${changed_files}"
    echo "::warning title=Changes left in $(${UTILS_DIR_PATH}/run.sh "get_repo_name")::${changed_files}"
  fi
}

main() {
  commit_changes
  validate_no_changes_left
}

main "$@"
