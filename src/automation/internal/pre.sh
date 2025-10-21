#!/usr/bin/env sh

SCRIPT_PATH=$(realpath "$0")
INTERNAL_DIR_PATH=$(dirname "${SCRIPT_PATH}")
AUTOMATION_DIR_PATH=$(dirname "${INTERNAL_DIR_PATH}")
SRC_DIR_PATH=$(dirname "${AUTOMATION_DIR_PATH}")
LIB_DIR_PATH="${SRC_DIR_PATH}/lib"

. "${LIB_DIR_PATH}/logging.sh"

main() {
  log_info "Setting up git config started."
  git config user.email "fabasoad@gmail.com"
  git config user.name "fabasoad"
  git config url."https://${GH_TOKEN}@github.com/".insteadOf "https://github.com/"
  log_info "Setting up git config completed."
}

main "$@"
