#!/usr/bin/env bash

set -euo pipefail

readonly store="$1"
sqlite_file="$(cat -)"; readonly sqlite_file
readonly dw_db_name='warehouse'
readonly pg_uri="${DATABASE_URL:-"postgresql:///${dw_db_name}"}"

readonly pgload_file_content="$(
  dhall text <<DH
    let afterLoad = ./sql/${store}/after_load.sql as Text

    in ./pgLoad.dhall "${sqlite_file}" "${pg_uri}" afterLoad
DH
)"

[ "${pgload_file_content}" == '' ] && exit 1

readonly pgload_file="$(mktemp -t "pgload_${store}_XXXXXXXX.sql")"

echo "${pgload_file_content}" > "${pgload_file}"
echo "${pgload_file}"

pgloader --no-ssl-cert-verification "${pgload_file}"
