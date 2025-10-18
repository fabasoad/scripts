#!/usr/bin/env sh

get_repo_name() {
  git remote get-url origin | cut -d ':' -f 2 | cut -d '.' -f 1
}
