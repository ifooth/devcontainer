# by devcontainer

# add go and python path
export PATH=/data/bin:/root/.go/bin:/opt/go/bin:/opt/python/notebook/bin:/root/.npm-packages/bin:$PATH

# uv
export UV_PYTHON_INSTALL_DIR=/opt/python/versions
export UV_LINK_MODE=copy

# ssh and vscode terminal use zsh
if [[ -n "${SSH_TTY}" ]] || [[ -n "${VSCODE_GIT_IPC_HANDLE}" ]];then
    exec zsh
fi