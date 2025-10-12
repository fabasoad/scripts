#!/usr/bin/env sh

SCRIPT_PATH=$(realpath "$0")
BUMP_PRE_COMMIT_DIR_PATH=$(dirname "${SCRIPT_PATH}")
AUTOMATION_DIR_PATH=$(dirname "${BUMP_PRE_COMMIT_DIR_PATH}")
SRC_DIR_PATH=$(dirname "${AUTOMATION_DIR_PATH}")
LIB_DIR_PATH="${SRC_DIR_PATH}/lib"

. "${LIB_DIR_PATH}/logging.sh"

main() {
  log_info "Running run-dependabot pre-automation script..."
  case "${RUNNER_OS}" in
    "Linux")
      os="linux"
      ;;
    "Windows")
      os="windows"
      ;;
    "macOS")
      os="darwin"
      ;;
    *)
      log_error "Unsupported OS: ${RUNNER_OS}"
      os=""
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
      log_error "Unsupported architecture: ${RUNNER_ARCH}"
      arch=""
      ;;
  esac
  if [ "${os}" = "windows" ] && [ "${arch}" = "arm64" ]; then
    log_error "Windows ARM64 is not supported by dependabot/cli"
    exit 0
  fi
  if [ -n "${os}" ] && [ -n "${arch}" ]; then
    log_info "Installing dependabot..."
    gh release download --repo dependabot/cli -p "*${os}-${arch}.tar.gz"
    tar xzvf *.tar.gz >/dev/null 2>&1
    mv dependabot "${RUNNER_TEMP}/bin/dependabot"
  fi
}

main "$@"
