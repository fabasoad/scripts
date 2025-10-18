#!/usr/bin/env sh

SCRIPT_PATH=$(realpath "$0")
AUTOMATION_DIR_PATH=$(dirname "${SCRIPT_PATH}")
AUTOMATION_BASE_DIR_PATH="${AUTOMATION_DIR_PATH}/base"
SRC_DIR_PATH=$(dirname "${AUTOMATION_DIR_PATH}")
LIB_DIR_PATH="${SRC_DIR_PATH}/lib"

. "${LIB_DIR_PATH}/logging.sh"
. "${AUTOMATION_BASE_DIR_PATH}/utils.sh"

setup_git_config() {
  log_info "Setting up git config started."
  git config user.email "fabasoad@gmail.com"
  git config user.name "fabasoad"
  git config url."https://${GH_TOKEN}@github.com/".insteadOf "https://github.com/"
  log_info "Setting up git config completed."
}

run_scripts() {
  log_info "Running automation scripts started."
  ${AUTOMATION_DIR_PATH}/ncu/main.sh
  ${AUTOMATION_DIR_PATH}/pre-commit/main.sh
  ${AUTOMATION_DIR_PATH}/pre-commit-prettier/main.sh
  log_info "Running automation scripts completed."
}

validate_no_changes_left() {
  set +e
  git diff --quiet
  exit_code=$?
  set -e

  if [ "${exit_code}" -eq 1 ]; then
    changed_files=$(git diff --name-only | awk '{printf "%s%s", sep, $0; sep = ", " } END {print ""}')
    log_warn "There are changes left after running automation scripts: ${changed_files}"
    echo "::warning title=Changes left in $(get_repo_name)::${changed_files}"
  fi
}

print_affected_repos() {
  affected_repos=$(sort "${CHANGED_REPOS_FILE_PATH}" | uniq | awk '{printf "%s%s", sep, $0; sep = ", " } END {print ""}')
  log_info "Affected repositories: ${affected_repos}"
  echo "::notice title=Affected repositories::${affected_repos}"
}

post_process() {
  validate_no_changes_left
  print_affected_repos
}

main() {
  setup_git_config
  run_scripts

  set +e
  git diff --quiet --staged
  exit_code=$?
  set -e

  if [ "${exit_code}" -eq 1 ]; then
    log_info "There are changes were made by automation scripts. Committing the changes..."
    git commit -m "chore: bump dependencies to the latest version"
    git push origin main
  else
    log_info "No changes were made by automation scripts"
  fi

  post_process
}

main "$@"
