#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi
cd "$(dirname "$0")"

fennel -c bench.fnl > bench.lua

# CPU time
hyperfine "lua -e '_G.benchmarking = true' bench.lua" "luajit -e '_G.benchmarking = true' bench.lua" --export-markdown result.md

# Memory statistics
{ echo "# Lua"; lua -e '_G.benchmarking = false' bench.lua; } >> result.md
{ echo "# Luajit"; luajit -e '_G.benchmarking = false' bench.lua; } >> result.md
