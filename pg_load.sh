#!/usr/bin/env bash

set -euo pipefail

readonly sqlite_file="$1"
readonly store="$2"
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

pgloader "${pgload_file}"
