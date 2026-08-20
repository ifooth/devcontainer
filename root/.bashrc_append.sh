# by devcontainer

# add go and python path
export PATH=/data/bin:/root/.go/bin:/root/.npm-packages/bin:/root/.local/bin:/opt/go/bin:/opt/python/notebook/bin:/opt/bin:$PATH

# uv
export UV_PYTHON_INSTALL_DIR=/opt/python/versions
export UV_LINK_MODE=copy

# ssh and vscode terminal use zsh
# Only for a real interactive terminal. `bash -ilc <script>` (used by tools such
# as cursor-agent to snapshot shell state) is also flagged interactive, but exec
# would discard the script, so require a tty and an empty BASH_EXECUTION_STRING.
if [[ $- == *i* ]] && [[ -z "${BASH_EXECUTION_STRING:-}" ]] && [[ -t 0 ]] && [[ -t 1 ]] &&
    [[ -z "${CURSOR_AGENT:-}" ]] && { [[ -n "${SSH_TTY:-}" ]] || [[ -n "${VSCODE_GIT_IPC_HANDLE:-}" ]]; }; then
    exec zsh
fi
