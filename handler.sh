#!/usr/bin/env bash

set -euo pipefail

query_string_to_tsv() {
  # This is a little out there and probably wildly inefficient, but it works…

  # gxargs -d '&' -n1 | tr '=' $'\t'
     xargs -d '&' -n1 | tr '=' $'\t'
}

query_tsv_includes() {
  local -r name="$1"
  grep -e "^${name}\t"
}

run() {
  local -r method="$1"
  local -r url="$2"
  # local -r proto="$3" # Not currently doing anything with this 🤷
  local -r respond="$4"

  if [ "${method}" != GET ] && [ "${method}" != HEAD ]; then
    >&2 echo "[ERROR] Rejected method: ${method}"
    $respond '405 Method Not Allowed'
    return 1
  fi

  local -r path="${url%%\?*}"

  # TODO: Maybe some changes to this path check
  if [ "${path}" != '/sqlite' ]; then
    >&2 echo "[ERROR] Rejected path: ${path}"
    $respond '404 Not Found'
    return 1
  fi

  local -r query_string="${url#*\?}"

  local -r query_tsv="$(
    query_string_to_tsv <<< "${query_string}"
  )"

  query_require() {
    local -r name="$1"
    query_tsv_includes "${name}" >/dev/null <<< "${query_tsv}" && return 0

    >&2 echo "[ERROR] Missing required query param: ${name}"
    $respond '400 Bad Request'
    return 1
  }

  query_get() {
    local -r name="$1"
    echo "${query_tsv}" | query_tsv_includes "${name}" | awk '{ print $2 }'
  }

  query_require sj_path
  query_require store

  local -r sj_path="$(query_get sj_path)"
  local -r store="$(query_get store)"

  local -r body="$(./load.sh "${store}" "${sj_path}")"

  $respond '202 Accepted' "${body}"
}

"$@"
