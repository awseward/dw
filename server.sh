#!/usr/bin/env bash

# Adapted from https://github.com/benrady/shinatra

set -euo pipefail

listen() {
  local -r response="HTTP/1.1 202 Accepted\r\nConnection: close\r\n\r\n${2:-"Accepted"}\r\n"

  local -r request="$(echo -en "$response" | nc -l "${1:-8080}" -w 1)"
  >&2 echo ">>>>> ${request}"
  local -r request_url="$(echo "${request}" | head -n1 | grep -o ' .* ')"

  local path; path="$(echo "${request_url}" | sed -e 's/^.* \(\/[^? ]*\)[? ].*$/\1/')"
  readonly path="${path,,}"

  case "${path}" in
    '/favicon.ico') : ;;

    '/sqlite')
      # shellcheck disable=SC2001
      local store; store="$(echo "${request_url}" | sed -e 's/^.*store=\([^& ]*\).*$/\1/')"
      readonly store="${store,,}"
      # shellcheck disable=SC2001
      local sj_path; sj_path="$(
        echo "${request_url}" | sed -e 's/^.*sj_path=\([^& ]*\).*$/\1/'
      )" readonly sj_path
      echo "${path} -- sj_path=${sj_path} store=${store}"
      ./load.sh "${store}" "${sj_path}"
      ;;

    (*) >&2 echo "[ERR] Rejected: ${path}"
  esac
}

run() {
  while true
  do
    >&2 echo "$0 listen $*"
    "$0" listen "$@" || (>&2 echo "ERROR…"; sleep 1)
  done
}

 "$@"
