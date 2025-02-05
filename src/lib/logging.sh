#!/usr/bin/env sh

# Printing log to the console.
# Parameters:
# 1. (Required) Log level. Options: debug, info, warning, error.
# 2. (Required) Message.
log() {
  printf "[%s] [%s] %s %s\n" "${1}" "${2}" "$(date +'%Y-%m-%d %T')" "${3}" 1>&2
}

log_info() {
  log "info" "${1}" "${2}"
}
