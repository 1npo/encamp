#!/usr/bin/bash
#
# Defines user settings
#

ARCH="x86_64"  # One of x86_64, arm64

BIN_DIR="${HOME}/.local/bin"
STATE_DIR="${HOME}/.local/state/encamp"
SHARE_DIR="${HOME}/.local/share/encamp"
CACHE_DIR="${HOME}/.cache/encamp"
mkdir -p "$BIN_DIR" "$STATE_DIR" "$SHARE_DIR" "$CACHE_DIR"

CREATE_GENERAL_VENV="true"
VENV_DIR="${HOME}/.venv"
VENV_PYTHON="${VENV_DIR}/bin/python"

