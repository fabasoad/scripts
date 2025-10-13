#!/usr/bin/env sh

get_latest_release() {
  repo="${1}"
  key=$(echo "${repo}" | sed 's/\//_/g')

  if [ -z "${STATE}_${key}" ]; then
    version=$(gh api \
      -H "Accept: application/vnd.github+json" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      "/repos/${repo}/releases?per_page=1" \
      --jq '.[].tag_name')
    echo "${key}=${version}" >> "${GITHUB_STATE}"
  else
    echo "Using cached value for ${repo}: ${STATE}_${key}"
  fi
  echo "${STATE}_${key}"
}
