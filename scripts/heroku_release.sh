#!/usr/bin/env bash

set -euo pipefail

eval "$(heroku_database_url_splitter)"
echo up | xargs -t shmig
