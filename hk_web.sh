#!/usr/bin/env bash

set -euo pipefail

export PATH="/app/bin:${PATH}"

./server.sh run "${PORT}"
