#!/usr/bin/env bash
set -e
PROGRAM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$(dirname "$PROGRAM_DIR")/lib/common.sh"
install_module "$PROGRAM_DIR"
