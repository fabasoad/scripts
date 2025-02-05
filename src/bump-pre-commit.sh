#!/usr/bin/env sh

SCRIPT_PATH=$(realpath "$0")
SRC_DIR_PATH=$(dirname "${SCRIPT_PATH}")
LIB_DIR_PATH="${SRC_DIR_PATH}/lib"

. "${LIB_DIR_PATH}/logging.sh"

main() {
  token="${1}"

  if [ -f ".pre-commit-config.yaml" ]; then
    pre-commit autoupdate

    set +e
    git diff --quiet
    exit_code=$?
    set -e

    if [ "${exit_code}" -eq 1 ]; then
      git config url."https://${token}@github.com/".insteadOf "https://github.com/"
      git add .
      git commit -m "chore: bump pre-commit hooks to the latest version"
      git push origin main
    else
      log_info "No changes in pre-commit hooks"
    fi
  else
    log_info ".pre-commit-config.yaml file is not found"
  fi
}

main "$@"
