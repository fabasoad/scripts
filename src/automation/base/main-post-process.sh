#!/usr/bin/env sh

main_post_process() {
  base_dir_path="${1}"

  set +e
  git diff --quiet --staged
  exit_code=$?
  set -e

  if [ "${exit_code}" -eq 1 ]; then
    . "${base_dir_path}/utils.sh"
    get_repo_name >> "${CHANGED_REPOS_FILE_PATH}"
  fi
}
