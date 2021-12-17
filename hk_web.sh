#!/usr/bin/env bash

set -euo pipefail

export PATH="/app/bin:${PATH}"

socat -v -v -d -d "TCP-LISTEN:${PORT}",reuseaddr,exec:'./http.sh exec ./handler.sh',pipes,crnl
