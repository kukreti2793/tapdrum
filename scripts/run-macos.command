#!/bin/bash
set -euo pipefail
tapdrum_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
"$tapdrum_root/scripts/build-macos.sh"
open "$tapdrum_root/.build/TapDrum.app"
