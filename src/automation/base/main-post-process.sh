#!/usr/bin/env sh

SCRIPT_PATH=$(realpath "$0")
AUTOMATION_BASE_DIR_PATH=$(dirname "${SCRIPT_PATH}")

. "${AUTOMATION_BASE_DIR_PATH}/utils.sh"

main_post_process() {
  set +e
  git diff --quiet --staged
  exit_code=$?
  set -e

  if [ "${exit_code}" -eq 1 ]; then
    get_repo_name >> "${CHANGED_REPOS_FILE_PATH}"
  fi
}
