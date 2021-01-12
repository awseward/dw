#!/usr/bin/env bash

set -euo pipefail

export PATH="/app/bin:${PATH}"

readonly exports="$(
  uq fmt-shell \
    --keys-prefix=DATABASE \
    --path-key=DATABASE_NAME \
    --path-lstrip-slash \
    "${DATABASE_URL}"
)"

eval "${exports}" && echo up | xargs -t shmig
