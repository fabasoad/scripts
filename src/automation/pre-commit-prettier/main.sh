#!/usr/bin/env sh

SCRIPT_PATH=$(realpath "$0")
BUMP_PRE_COMMIT_DIR_PATH=$(dirname "${SCRIPT_PATH}")
AUTOMATION_DIR_PATH=$(dirname "${BUMP_PRE_COMMIT_DIR_PATH}")
SRC_DIR_PATH=$(dirname "${AUTOMATION_DIR_PATH}")
LIB_DIR_PATH="${SRC_DIR_PATH}/lib"

. "${LIB_DIR_PATH}/get-latest-release.sh"
. "${LIB_DIR_PATH}/logging.sh"

main() {
  log_info "Running pre-commit-prettier automation script..."
  if [ -f ".pre-commit-config.yaml" ]; then
    dep=$(yq '.repos[] | select(.repo == "local") | .hooks[] | select(.id == "prettier") | .additional_dependencies[] | select(test("^prettier"))' ".pre-commit-config.yaml")
    current_version=$(echo "${dep}" | sed -E 's/^prettier@//')
    latest_version=$(get_latest_release "prettier/prettier" | sed -E 's/^v//')
    if [ "${current_version}" != "${latest_version}" ]; then
      log_info "Updating prettier from version ${current_version} to ${latest_version}"
      yq -i '(.repos[] | select(.repo == "local") | .hooks[] | select(.id == "prettier") | .additional_dependencies[] | select(test("^prettier"))) = "prettier@'"${latest_version}"'"' ".pre-commit-config.yaml"
    else
      log_info "prettier is already at the latest version ${latest_version}"
    fi
  else
    log_info ".pre-commit-config.yaml file is not found"
  fi
}

main "$@"
