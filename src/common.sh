#!/usr/bin/env sh

log() {
  prefix="[$1]"
  level=$2
  msg=$3

  printf "%s %s level=%s %s\n" "$prefix" "$(date +'%Y-%m-%d %T')" "$level" "$msg"
}

logInfo() {
  log "info" "$1"
}
