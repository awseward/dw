#!/usr/bin/env bash

set -euo pipefail

export PATH="/app/bin:${PATH}"

eval "$(heroku_database_url_splitter)" && echo up | xargs -t shmig
