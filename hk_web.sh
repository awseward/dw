#!/usr/bin/env bash

set -euo pipefail

export PATH="${HOME}/bin:${PATH}"

./server.sh run "${PORT}"
