#!/usr/bin/env sh

SCRIPT_PATH=$(realpath "$0")
BUMP_PRE_COMMIT_DIR_PATH=$(dirname "${SCRIPT_PATH}")
AUTOMATION_DIR_PATH=$(dirname "${BUMP_PRE_COMMIT_DIR_PATH}")
SRC_DIR_PATH=$(dirname "${AUTOMATION_DIR_PATH}")
LIB_DIR_PATH="${SRC_DIR_PATH}/lib"

. "${LIB_DIR_PATH}/logging.sh"

main() {
  log_info "Running pre-commit post-automation script..."
  if command -v pre-commit >/dev/null 2>&1; then
    pip uninstall pre-commit
  fi
}

main "$@"
