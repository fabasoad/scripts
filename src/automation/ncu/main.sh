#!/usr/bin/env sh

SCRIPT_PATH=$(realpath "$0")
SCRIPT_DIR_PATH=$(dirname "${SCRIPT_PATH}")
AUTOMATION_DIR_PATH=$(dirname "${SCRIPT_DIR_PATH}")
SRC_DIR_PATH=$(dirname "${AUTOMATION_DIR_PATH}")
LIB_DIR_PATH="${SRC_DIR_PATH}/lib"

. "${LIB_DIR_PATH}/logging.sh"

main() {
  log_info "Running ncu automation script..."
  if [ -f "package.json" ]; then
    ncu --upgrade --target patch
    if [ -f yarn.lock ]; then
      rm -f yarn.lock
      YARN_ENABLE_IMMUTABLE_INSTALLS=false yarn install
    elif [ -f package-lock.json ]; then
      rm -f package-lock.json
      npm install
    elif [ -f pnpm-lock.yaml ]; then
      rm -f pnpm-lock.yaml
      pnpm install
    fi
    # If this is a GitHub Action, we need to rebuild the dist directory
    if [ -f dist/index.js ]; then
      make build || true
    fi
  else
    log_info "package.json file is not found"
  fi
}

main "$@"
