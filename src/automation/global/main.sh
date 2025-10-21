#!/usr/bin/env sh

SCRIPT_PATH=$(realpath "$0")
GLOBAL_DIR_PATH=$(dirname "${SCRIPT_PATH}")
AUTOMATION_DIR_PATH=$(dirname "${GLOBAL_DIR_PATH}")
SRC_DIR_PATH=$(dirname "${AUTOMATION_DIR_PATH}")
LIB_DIR_PATH="${SRC_DIR_PATH}/lib"

. "${LIB_DIR_PATH}/logging.sh"

print_affected_repos() {
  affected_repos=$(sort "${CHANGED_REPOS_FILE_PATH}" | uniq | awk '{printf "%s%s", sep, $0; sep = ", " } END {print ""}')
  log_info "Affected repositories: ${affected_repos}"
  echo "::notice title=Affected repositories::${affected_repos}"
}

post_process() {
  print_affected_repos
}

main() {
  input_regex="${1}"

  gh foreach run \
    --cleanup \
    --no-confirm \
    --shell $(which sh) \
    --visibility public \
    --affiliations owner \
    --regex "${input_regex}" \
    ${AUTOMATION_DIR_PATH}/run.sh

  post_process
}

main "$@"
