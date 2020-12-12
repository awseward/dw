#!/usr/bin/env bash

set -euo pipefail

readonly sqlite_filepath="$1"
readonly dw_db_name='warehouse'
readonly pg_target="${DATABASE_URL:-"postgresql:///${dw_db_name}"}"

psql "${pg_target}" -c 'SELECT 0;' >/dev/null || createdb "${dw_db_name}"

readonly load_file="$(mktemp -t 'pg_load_git_events_XXXXXXXX.sql')"
dhall text <<< "./loadGitEvents.dhall \"${sqlite_filepath}\" \"${pg_target}\"" \
  | tee "${load_file}"
pgloader "${load_file}"
