#!/usr/bin/env sh

SCRIPT_PATH=$(realpath "$0")
AUTOMATION_DIR_PATH=$(dirname "${SCRIPT_PATH}")
SRC_DIR_PATH=$(dirname "${AUTOMATION_DIR_PATH}")
LIB_DIR_PATH="${SRC_DIR_PATH}/lib"

. "${LIB_DIR_PATH}/logging.sh"

setup_git_config() {
  app_slug="${1}"
  token="${2}"

  log_info "Setting up git config started."
  app_name="${app_slug}[bot]"
  user_id="$(gh api "/users/${app_name}" --jq .id)"
  log_info "User ID: ${user_id}"
  git config user.email "${user_id}+${app_name}@users.noreply.github.com"
  git config user.name "${app_name}"
  git config url."https://${token}@github.com/".insteadOf "https://github.com/"
  log_info "Setting up git config completed."
}

run_scripts() {
  log_info "Running automation scripts started."
  ${AUTOMATION_DIR_PATH}/bump-pre-commit/main.sh
  ${AUTOMATION_DIR_PATH}/run-dependabot/main.sh
  log_info "Running automation scripts completed."
}

main() {
  app_slug="${1}"
  token="${2}"
  echo "Directory 2: $(pwd)"

  setup_git_config "${app_slug}" "${token}"
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
