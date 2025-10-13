#!/usr/bin/env sh

SCRIPT_PATH=$(realpath "$0")
AUTOMATION_DIR_PATH=$(dirname "${SCRIPT_PATH}")
SRC_DIR_PATH=$(dirname "${AUTOMATION_DIR_PATH}")
LIB_DIR_PATH="${SRC_DIR_PATH}/lib"

. "${LIB_DIR_PATH}/logging.sh"

setup_git_config() {
  log_info "Setting up git config started."
  git config user.email "fabasoad@gmail.com"
  git config user.name "fabasoad"
  git config url."https://${GH_TOKEN}@github.com/".insteadOf "https://github.com/"
  log_info "Setting up git config completed."
}

run_scripts() {
  log_info "Running automation scripts started."
  ${AUTOMATION_DIR_PATH}/pre-commit/main.sh
  ${AUTOMATION_DIR_PATH}/pre-commit-prettier/main.sh
  log_info "Running automation scripts completed."
}

main() {
  setup_git_config
  run_scripts

  set +e
  git diff --quiet
  exit_code=$?
  set -e

  if [ "${exit_code}" -eq 1 ]; then
    log_info "There are changes were made by automation scripts. Committing the changes..."
    git add .
    git commit -m "chore: bump dependencies to the latest version"
    git push origin main
  else
    log_info "No changes were made by automation scripts"
  fi
}

main "$@"
