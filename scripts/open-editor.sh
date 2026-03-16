#!/bin/bash
# Smart opener for VSCode / Cursor remote server instances.
# Create symlinks named 'vscode' and 'cursor' pointing to this script,
# then use: vscode <path> / cursor <path>
set -euo pipefail

CMD_NAME="$(basename "$0")"

case "$CMD_NAME" in
  vscode|code)
    SERVER_DIR_PATTERN=".vscode-server"
    DISPLAY_NAME="VSCode"
    ;;
  cursor)
    SERVER_DIR_PATTERN=".cursor-server"
    DISPLAY_NAME="Cursor"
    ;;
  *)
    echo "Error: invoke as 'vscode <path>' or 'cursor <path>'"
    echo "Create symlinks: ln -s $(readlink -f "$0") /usr/local/bin/vscode"
    echo "                 ln -s $(readlink -f "$0") /usr/local/bin/cursor"
    exit 1
    ;;
esac

# Find the main server process (server-main.js, NOT extensionHost)
SERVER_PID=""
SERVER_NODE=""
while IFS= read -r pid; do
  cmdline=$(tr '\0' ' ' < /proc/"$pid"/cmdline 2>/dev/null) || continue
  if [[ "$cmdline" == *"$SERVER_DIR_PATTERN"* ]] \
     && [[ "$cmdline" == *"server-main.js"* ]] \
     && [[ "$cmdline" != *"--type=extensionHost"* ]]; then
    SERVER_PID="$pid"
    SERVER_NODE="${cmdline%% *}"
    break
  fi
done < <(pgrep -x node 2>/dev/null)

if [[ -z "$SERVER_PID" ]]; then
  echo "✗ No running $DISPLAY_NAME server process found." >&2
  exit 1
fi

# Derive install dir from the node binary path
SERVER_BASE="$(dirname "$SERVER_NODE")"

# Locate CLI binary: prefer 'cursor' for Cursor, fallback to 'code'
CLI_BIN=""
for name in "$CMD_NAME" code; do
  candidate="$SERVER_BASE/bin/remote-cli/$name"
  if [[ -x "$candidate" ]]; then
    CLI_BIN="$candidate"
    break
  fi
done

if [[ -z "$CLI_BIN" ]]; then
  echo "✗ CLI binary not found under $SERVER_BASE/bin/remote-cli/" >&2
  exit 1
fi

# Find IPC socket owned by the main server PID
IPC_SOCK="$(ss -lnpx 2>/dev/null \
  | grep "pid=${SERVER_PID}," \
  | grep -oP '/tmp/vscode-ipc-\S+' \
  | head -1)"

if [[ -z "$IPC_SOCK" ]]; then
  echo "✗ No available IPC socket for $DISPLAY_NAME (server PID=$SERVER_PID)." >&2
  exit 1
fi

export VSCODE_IPC_HOOK_CLI="$IPC_SOCK"
exec "$CLI_BIN" "$@"