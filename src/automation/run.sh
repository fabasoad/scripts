#!/usr/bin/env sh

SCRIPT_PATH=$(realpath "$0")
AUTOMATION_DIR_PATH=$(dirname "${SCRIPT_PATH}")
INTERNAL_DIR_PATH="${AUTOMATION_DIR_PATH}/internal"

main() {
  ${INTERNAL_DIR_PATH}/pre.sh "$@"
  ${INTERNAL_DIR_PATH}/main.sh "$@"
  ${INTERNAL_DIR_PATH}/post.sh "$@"
}

main "$@"
