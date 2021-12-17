#!/usr/bin/env bash

# Adapted from https://github.com/benrady/shinatra

readonly response="HTTP/1.1 202 Accepted\r\nConnection: close\r\n\r\n${2:-"Accepted"}\r\n"

while true; do
  ( set -euo pipefail

    readonly request="$(echo -en "$response" | nc -l "${1:-8080}" -w 1)"
    readonly request_url="$(echo "${request}" | head -n1 | grep -o ' .* ')"

    path="$(echo "${request_url}" | sed -e 's/^.* \(\/[^? ]*\)[? ].*$/\1/')"
    readonly path="${path,,}"

    case "${path}" in
      '/favicon.ico') : ;;

      '/sqlite')
        # shellcheck disable=SC2001
        store="$(echo "${request_url}" | sed -e 's/^.*store=\([^& ]*\).*$/\1/')"
        readonly store="${store,,}"
        # shellcheck disable=SC2001
        readonly sj_path="$(
          echo "${request_url}" | sed -e 's/^.*sj_path=\([^& ]*\).*$/\1/'
        )"
        echo "${path} -- sj_path=${sj_path} store=${store}"
        ./load.sh "${store}" "${sj_path}"
        ;;

      (*) >&2 echo "[ERR] Rejected: ${path}"
    esac
  )
done
