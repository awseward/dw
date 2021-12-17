#!/usr/bin/env bash

set -euo pipefail

# socat -v -v -d -d TCP-LISTEN:8080,reuseaddr,fork exec:'./http.sh exec ./handler.sh',pipes,crnl
exec() {
  echo -e "HTTP/1.1 202 Accepted\nContent-Length: 0\nConnection: keep-alive"
  return 0
  # ---

  local -r handler="$1"

  local -r full_request="$(cat -)"

  # shellcheck disable=SC2046
  read -r method url proto <<< $(head -n1 <<< "${full_request}")

  # "${handler}" run "${method}" "${url}" "${proto}" "$0 respond ${proto}"
  >&2 echo "${handler} run ${method} ${url} ${proto} '$0 respond ${proto}'"

  respond "${proto}" '202 Accepted' \
    "${handler} run ${method} ${url} ${proto} '$0 respond ${proto}'"
}

respond() {
  local -r proto="$1"
  local -r status="$2" # E.g. '202 Accepted'
  local -r body="${3:-}"

  local response="${proto} ${status}\nConnection: close"

  if [ "${body}" != '' ]; then
    response="${response}\n\n${body}"
  fi
  readonly response

  echo -e "${response}"
}

"$@"
