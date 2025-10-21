#!/usr/bin/env sh

main() {
  log_info "Setting up git config started."
  git config user.email "fabasoad@gmail.com"
  git config user.name "fabasoad"
  git config url."https://${GH_TOKEN}@github.com/".insteadOf "https://github.com/"
  log_info "Setting up git config completed."
}

main "$@"
