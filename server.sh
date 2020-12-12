#!/usr/bin/env bash

# Adapted from https://github.com/benrady/shinatra

readonly response="HTTP/1.1 202 Accepted\r\nConnection: keep-alive\r\n\r\n${2:-"Accepted"}\r\n"

access_name="$(mktemp -u -t sj-access-XXXXXXXXXXXXXXXX | xargs basename)"
readonly access_name="${access_name,,}"

uplink import "${access_name}" "${SJ_ACCESS}"
export SJ_ACCESS="${access_name}"

# echo "${SJ_ACCESS}" | xargs -t uplink ls "sj://${SJ_BUCKET}" --access

while true; do
  ( set -euo pipefail

    readonly request="$(echo -en "$response" | nc -l "${1:-8080}" -w 1)"
    readonly request_url="$(echo "${request}" | head -n1 | grep -o ' .* ')"

    path="$(echo "${request_url}" | sed -e 's/^.* \(\/[^? ]*\)[? ].*$/\1/')"
    readonly path="${path,,}"

    case "${path}" in
      '/favicon.ico') : ;;

      '/sqlite')
        store="$(echo "${request_url}" | sed -e 's/^.*store=\([^& ]*\).*$/\1/')"
        readonly store="${store,,}"

        case "${store}" in
          'git-events')
            readonly pg_load_script='./pg_load_git_events.sh'
            ;;

          'health-events')
            readonly pg_load_script='./pg_load_health_events.sh'
            ;;

          'call-events')
            readonly pg_load_script='./pg_load_call_events.sh'
            ;;

          *) >&2 echo "[ERR] Rejected: ${path} -- store=${store}"; exit 1
        esac

        readonly sj_path="$(echo "${request_url}" | sed -e 's/^.*sj_path=\([^& ]*\).*$/\1/')"
        echo "${path} -- sj_path=${sj_path} store=${store}"

        echo "${sj_path}" \
          | xargs -t ./sj_pull.sh \
          | xargs -t "${pg_load_script}"
        ;;

      (*) >&2 echo "[ERR] Rejected: ${path}"
    esac
  )
done
