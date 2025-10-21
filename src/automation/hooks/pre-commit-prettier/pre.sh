#!/usr/bin/env sh

SCRIPT_PATH=$(realpath "$0")
SCRIPT_DIR_PATH=$(dirname "${SCRIPT_PATH}")
HOOKS_DIR_PATH=$(dirname "${SCRIPT_DIR_PATH}")
AUTOMATION_DIR_PATH=$(dirname "${HOOKS_DIR_PATH}")
SRC_DIR_PATH=$(dirname "${AUTOMATION_DIR_PATH}")
LIB_DIR_PATH="${SRC_DIR_PATH}/lib"

. "${LIB_DIR_PATH}/logging.sh"

setup_pre_commit() {
  if command -v pre-commit >/dev/null 2>&1; then
    log_info "pre-commit is found at $(which pre-commit). Installation skipped."
  else
    pip install pre-commit
  fi
}

setup_yq() {
  ext=""
  case "${RUNNER_OS}" in
    "Linux")
      os="linux"
      ;;
    "Windows")
      os="windows"
      ext=".exe"
      ;;
    "macOS")
      os="darwin"
      ;;
    *)
      log_error "Unsupported OS: ${RUNNER_OS:-"N/A"}"
      exit 0
      ;;
  esac
  case "${RUNNER_ARCH}" in
    "X64" | "x86")
      arch="amd64"
      ;;
    "ARM64" | "ARM")
      arch="arm64"
      ;;
    *)
      log_error "Unsupported architecture: ${RUNNER_ARCH:-"N/A"}"
      exit 0
      ;;
  esac
  if command -v yq${ext} >/dev/null 2>&1; then
    log_info "yq is found at $(which yq${ext}). Installation skipped."
  else
    bundle="yq_${os}_${arch}${ext}"
    gh release download --repo mikefarah/yq -p "${bundle}"
    log_info "$(./${bundle} --version) installed successfully."
    mv ${bundle} "${BIN_DIR_PATH}/yq${ext}"
  fi
}

main() {
  log_info "Running pre-commit-prettier pre-automation script..."
  setup_pre_commit
  setup_yq
}

main "$@"
