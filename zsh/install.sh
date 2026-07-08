#!/usr/bin/env bash
# Backward-compatible entrypoint. Root install.sh owns full machine bootstrap.
set -euo pipefail
ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
exec "$ROOT_DIR/install.sh" "$@"
