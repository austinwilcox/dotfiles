#!/usr/bin/env bash
# Install kmonad as a systemd system service and remove the @reboot cron entry
# that used to start it. Run with sudo.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UNIT_SRC="$DOTFILES_DIR/kmonad.service"
UNIT_DST=/etc/systemd/system/kmonad.service
CRONTAB=/etc/crontab

if [[ $EUID -ne 0 ]]; then
  echo "error: must run as root (sudo $0)" >&2
  exit 1
fi

[[ -f "$UNIT_SRC" ]] || { echo "error: $UNIT_SRC not found" >&2; exit 1; }

# Symlink so edits in the dotfiles repo take effect after a daemon-reload.
ln -sfn "$UNIT_SRC" "$UNIT_DST"
echo "linked $UNIT_DST -> $UNIT_SRC"

# Drop the old @reboot line so kmonad is not started twice.
if grep -q '^@reboot root .*kmonad' "$CRONTAB"; then
  cp -a "$CRONTAB" "$CRONTAB.bak.$(date +%Y%m%d%H%M%S)"
  sed -i '/^@reboot root .*kmonad/d' "$CRONTAB"
  echo "removed @reboot kmonad line from $CRONTAB (backup saved)"
else
  echo "no @reboot kmonad line in $CRONTAB, nothing to remove"
fi

# Stop whatever cron already started this boot, then hand over to systemd.
pkill -f 'kmonad .*\.kbd' || true

systemctl daemon-reload
systemctl enable --now kmonad.service
systemctl --no-pager status kmonad.service || true
