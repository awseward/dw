#!/usr/bin/env bash

set -euo pipefail

_create_lowercase_id() {
  local -r id="$(mktemp -u -t XXXXXXXXXXXXXXXX | xargs basename)"
  echo "${id,,}"
}

_etablish_sj_access() {
  local -r access_name="sj-access-$(_create_lowercase_id)"
  >&2 uplink import "${access_name}" "${SJ_ACCESS}"
  echo "${access_name}"
}

_uplink_cp() {
  local -r src="${1}"
  local -r dest="${2}"
  xargs -t >&2 uplink cp "${src}" "${dest}" --progress=false --access
}

_cleanup() {
  xargs -t rm -rf "$1" || true
}

pull_sj() {
  local -r src="$(cat -)"
  local -r sqlite_filepath="$(mktemp -t XXXXXXXX.db)"

  (
    _etablish_sj_access | _uplink_cp "${src}" "${sqlite_filepath}"
    # Need to clean this up because imported accesses get stored here…
    _cleanup "${HOME}/.local/share/storj/uplink/config.yaml"
  ) || (
    # Need to clean this up because imported accesses get stored here…
    _cleanup "${HOME}/.local/share/storj/uplink/config.yaml"
  )

  echo "${sqlite_filepath}"
}

load_pg() {
  local -r store="$1"
  local -r sqlite_file="$(cat -)"

  local -r dw_db_name='warehouse'
  local -r pg_uri="${DATABASE_URL:-"postgresql:///${dw_db_name}"}"
  local -r pgload_file="$(mktemp -t "XXXXXXXX.sql")"

  AFTERLOAD="./sql/${store}/after_load.sql as Text" \
    SQLITE_FILE="${sqlite_file}" \
    PG_URI="${pg_uri}" \
    dhall text  --file './pgLoad.dhall' --output "${pgload_file}"

  xargs -t pgloader --no-ssl-cert-verification <<< "${pgload_file}"

  _cleanup "${pgload_file}"
  _cleanup "${sqlite_file}"
}

"$@"
