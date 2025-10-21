#!/usr/bin/env sh

SCRIPT_PATH=$(realpath "$0")
GLOBAL_DIR_PATH=$(dirname "${SCRIPT_PATH}")
AUTOMATION_DIR_PATH=$(dirname "${GLOBAL_DIR_PATH}")
HOOKS_DIR_PATH="${AUTOMATION_DIR_PATH}/hooks"
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
  for dir in ${HOOKS_DIR_PATH}/*; do
    if [ -d "${dir}" ] && [ -f "${dir}/post.sh" ]; then
      ${dir}/post.sh
    fi
  done
  log_info "Running post-automation scripts completed."
}

main "$@"
