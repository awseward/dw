#!/usr/bin/env bash

set -euo pipefail

# === BEGIN 🤷 ===
access_name="$(mktemp -u -t sj-access-XXXXXXXXXXXXXXXX | xargs basename)"
readonly access_name="${access_name,,}"
uplink import "${access_name}" "${SJ_ACCESS}"
export SJ_ACCESS="${access_name}"
# === END 🤷 ===

run() {
  local -r store="$1"
  local -r sj_path="$2"

  echo "${sj_path}" \
    | xargs -t ./sj_pull.sh \
    | xargs -t ./pg_load.sh "${store}"
}

run "$@"
