#!/usr/bin/env sh

SCRIPT_PATH=$(realpath "$0")
AUTOMATION_DIR_PATH=$(dirname "${SCRIPT_PATH}")
SRC_DIR_PATH=$(dirname "${AUTOMATION_DIR_PATH}")
LIB_DIR_PATH="${SRC_DIR_PATH}/lib"

. "${LIB_DIR_PATH}/logging.sh"

main() {
  echo "Directory 2: $(pwd)"
  log_info "Running automation scripts started."
  ${AUTOMATION_DIR_PATH}/bump-pre-commit/main.sh
  ${AUTOMATION_DIR_PATH}/run-dependabot/main.sh
  log_info "Running automation scripts completed."

  set +e
  git diff --quiet
  exit_code=$?
  set -e

  if [ "${exit_code}" -eq 1 ]; then
    log_info "There are changes were made by automation scripts. Committing the changes..."
    git add .
    git commit -m "chore: bump dependencies to the latest version"
    git push origin main
  else
    log_info "No changes were made by automation scripts"
  fi
}

main "$@"
