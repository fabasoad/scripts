#!/usr/bin/env sh

SCRIPT_PATH=$(realpath "$0")
INTERNAL_DIR_PATH=$(dirname "${SCRIPT_PATH}")
AUTOMATION_DIR_PATH=$(dirname "${INTERNAL_DIR_PATH}")
HOOKS_DIR_PATH="${AUTOMATION_DIR_PATH}/hooks"
SRC_DIR_PATH=$(dirname "${AUTOMATION_DIR_PATH}")
LIB_DIR_PATH="${SRC_DIR_PATH}/lib"

. "${LIB_DIR_PATH}/logging.sh"

main() {
  log_info "Running automation scripts started."
  for dir in ${HOOKS_DIR_PATH}/*; do
    if [ -d "${dir}" ] && [ -f "${dir}/main.sh" ]; then
      ${dir}/main.sh
    fi
  done
  log_info "Running automation scripts completed."
}

main "$@"
