#!/usr/bin/bash
#
# Installs encamp on a new machine by cloning the repository and installing symlinks
#
# To install encamp with this script, run:
#   
#   curl -fsSL https://raw.githubusercontent.com/<user>/encamp-v2/main/install.sh | bash
#
# Usage examples:
#
#   Encamp on a new machine that's a 'desktop' target:
#
#       encamp base all
#       encamp desktop all
#
#   Only install packages on a new 'desktop' target:
#
#       encamp desktop packages
#
#   Only set up user configuration on a new 'desktop' target:
#
#       encamp desktop config-user
#   
#   Push local user configuration changes to git remote:
#
#       encamp-sync push "updated my dotfiles"
#
#   Update local user configuration with most recent updates from git remote:
#
#       encamp-sync pull
#

REPO_URL="https://github.com/1npo/encamp-v2.git"
SHARE_DIR="${HOME}/.local/share/encamp"
BIN_DIR="${HOME}/.local/bin"

mkdir -p "$SHARE_DIR" "$BIN_DIR"

log() {
    echo "===> $*"
}

if ! command -v git &>/dev/null; then
    log "Error: git is required but not found in \$PATH"
    exit 1
fi

if [ -d "${SHARE_DIR}/.git" ]; then
    log "Repository already exists at ${SHARE_DIR}, skipping clone"
else
    log "Cloning encamp into ${SHARE_DIR}..."
    git clone "${REPO_URL}" "${SHARE_DIR}"
fi

log "Installing symlinks in ${BIN_DIR}..."
ln -sf "${SHARE_DIR}/scripts/main.sh" "${BIN_DIR}/encamp"
ln -sf "${SHARE_DIR}/scripts/sync.sh" "${BIN_DIR}/encamp-sync"
chmod +x "${SHARE_DIR}/scripts/main.sh" "${SHARE_DIR}/scripts/sync.sh"

log "Done. You can now run: encamp <target> <module>"