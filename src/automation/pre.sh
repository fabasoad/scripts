#!/usr/bin/env sh

SCRIPT_PATH=$(realpath "$0")
AUTOMATION_DIR_PATH=$(dirname "${SCRIPT_PATH}")
SRC_DIR_PATH=$(dirname "${AUTOMATION_DIR_PATH}")
LIB_DIR_PATH="${SRC_DIR_PATH}/lib"

. "${LIB_DIR_PATH}/logging.sh"

main() {
  mkdir -p "${RUNNER_TEMP}/bin"
  echo "${RUNNER_TEMP}/bin" >> "${GITHUB_PATH}"

  log_info "Running pre-automation scripts started."
  ${AUTOMATION_DIR_PATH}/pre-commit/pre.sh
  ${AUTOMATION_DIR_PATH}/pre-commit-prettier/pre.sh
  log_info "Running pre-automation scripts completed."
}

main "$@"
