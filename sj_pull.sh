#!/usr/bin/env bash

set -euo pipefail

url="$(cat)"; readonly url
sqlite_filepath="$(mktemp -t pulled_sqlite-XXXXXXXX.db)"; readonly sqlite_filepath
readonly sj_access="${SJ_ACCESS:-dw-read}"

echo "${sj_access}" | xargs -t >&2 uplink cp "${url}" "${sqlite_filepath}" --progress=false --access

echo "${sqlite_filepath}"
