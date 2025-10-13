#!/usr/bin/env sh

get_latest_release() {
  repo="${1}"
  key=$(echo "${repo}" | sed 's/\//_/g')
  cache_file_path="${CACHE_DIR_PATH}/latest_version_${key}"

  if [ ! -f "${cache_file_path}" ]; then
    version=$(gh api \
      -H "Accept: application/vnd.github+json" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      "/repos/${repo}/releases?per_page=1" \
      --jq '.[].tag_name')
    echo "${version}" > "${cache_file_path}"
  fi
  head -n 1 "${cache_file_path}"
}
