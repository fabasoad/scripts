#!/usr/bin/env sh

SCRIPT_PATH=$(realpath "$0")
SCRIPT_DIR_PATH=$(dirname "${SCRIPT_PATH}")
HOOKS_DIR_PATH=$(dirname "${SCRIPT_DIR_PATH}")
AUTOMATION_DIR_PATH=$(dirname "${HOOKS_DIR_PATH}")
SRC_DIR_PATH=$(dirname "${AUTOMATION_DIR_PATH}")
LIB_DIR_PATH="${SRC_DIR_PATH}/lib"

. "${LIB_DIR_PATH}/logging.sh"

main() {
  log_info "Running ncu automation script..."
  if [ -f "package.json" ]; then
    ncu --upgrade --target patch
    if [ -f yarn.lock ]; then
      YARN_ENABLE_IMMUTABLE_INSTALLS=false yarn install
      git add yarn.lock
    elif [ -f package-lock.json ]; then
      npm install
      git add package-lock.json
    elif [ -f pnpm-lock.yaml ]; then
      pnpm install --no-frozen-lockfile
      git add pnpm-lock.yaml
    fi
    git add package.json
    # If this is a GitHub Action, we need to rebuild the dist directory
    if [ -f dist/index.js ]; then
      make build || true
    fi
    git add dist/
  else
    log_info "package.json file is not found"
  fi
}

main "$@"
