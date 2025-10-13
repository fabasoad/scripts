#!/usr/bin/env sh

SCRIPT_PATH=$(realpath "$0")
AUTOMATION_DIR_PATH=$(dirname "${SCRIPT_PATH}")
SRC_DIR_PATH=$(dirname "${AUTOMATION_DIR_PATH}")
LIB_DIR_PATH="${SRC_DIR_PATH}/lib"

. "${LIB_DIR_PATH}/logging.sh"

cleanup_environment() {
  rm -rf "${BIN_DIR_PATH}"
  rm -rf "${CACHE_DIR_PATH}"
}

main() {
  log_info "Cleaning up environment..."
  cleanup_environment
  log_info "Running post-automation scripts started."
  ${AUTOMATION_DIR_PATH}/ncu/post.sh
  ${AUTOMATION_DIR_PATH}/pre-commit/post.sh
  ${AUTOMATION_DIR_PATH}/pre-commit-prettier/post.sh
  log_info "Running post-automation scripts completed."
}

main "$@"
