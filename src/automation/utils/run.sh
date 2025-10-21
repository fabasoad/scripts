#!/usr/bin/env sh

SCRIPT_PATH=$(realpath "$0")
UTILS_DIR_PATH=$(dirname "${SCRIPT_PATH}")

main() {
  python "${UTILS_DIR_PATH}/${1}.py"
}

main "$@"
