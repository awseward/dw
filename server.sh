#!/usr/bin/env bash

# Adapted from https://github.com/benrady/shinatra

set -euo pipefail

listen() {
  local -r listen_port="${1:-8080}"
  >&2 echo "Listening on :${listen_port}"
  local -r resp_file='./http202.txt'
  nc -l "${listen_port}" < "${resp_file}"
}

handle() {
  local -r req="$(cat -)"
  local -r request_url="$(echo "${req}" | head -n1 | grep -o ' .* ')"
  local path; path="$(echo "${request_url}" | sed -e 's/^.* \(\/[^? ]*\)[? ].*$/\1/')"
  readonly path="${path,,}"

  [ "${path}" = '' ] && return 1

  case "${path}" in
    '/sqlite')
      local store; store="$(
        # shellcheck disable=SC2001
        echo "${request_url}" | sed -e 's/^.*store=\([^& ]*\).*$/\1/'
      )"
      readonly store="${store,,}"

      local -r load_script='./load.sh'

      echo "${request_url}" \
        | sed -e 's/^.*sj_path=\([^& ]*\).*$/\1/' \
        | "${load_script}" pull_sj \
        | "${load_script}" load_pg "${store}"
      ;;

    (*) >&2 echo "Discarded: ${path}"
  esac
}

run() {
  while true
  do
    listen "$@" | handle \
      || (echo '…'; sleep '0.5')
  done
}

"$@"
