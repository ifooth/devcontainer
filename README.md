# DevContainer
Full stack remote development environment

[![Docker](https://github.com/ifooth/devcontainer/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/ifooth/devcontainer/actions/workflows/docker-publish.yml)

Base on [vscode-dev-containers](https://github.com/microsoft/vscode-dev-containers) image

## Shell
- [zsh](https://www.zsh.org/)
- [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh)
- [git](https://github.com/git/git)
- [fzf](https://github.com/junegunn/fzf) - A command-line fuzzy finder
- [autojump](https://github.com/wting/autojump) - A cd command that learns - easily navigate directories from the command line
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)


## Vim
Plugin
- https://github.com/scrooloose/nerdtree.git
- https://github.com/kien/ctrlp.vim.git
- https://github.com/easymotion/vim-easymotion.git
- https://github.com/rking/ag.vim.git

- https://github.com/vim-airline/vim-airline
- https://github.com/vim-airline/vim-airline-themes
- https://github.com/altercation/vim-colors-solarized.git
- https://github.com/scrooloose/nerdcommenter

## Python
- [pyenv](https://github.com/pyenv/pyenv)

usage
```shell
# switch python version
pyenv versions
export PYENV_VERSION=3.10.1

# use virtualenv
mkvirtualenv -p /opt/pyenv/versions/3.10.1/bin/python hello-world
```

## Golang
- [gvm](https://github.com/moovweb/gvm)

## Utils
- [cloc](https://github.com/AlDanial/cloc)
- [android adb](https://developer.android.com/studio/releases/platform-tools)


## Settings
vscode remote ssh settings

~/.vscode-server/data/Machine/settings.json

```json
{
    "go.goroot": "/opt/gvm/gos/go1.17.6",
    "python.linting.flake8Path": "/usr/local/bin/flake8",
    "python.formatting.blackPath": "/usr/local/bin/black"
}
```

## Tips and Tricks

### windows remote ssh cann't connection with zsh

error log:
```bash
zsh: bad math expression: operand expected at `*100000 + ...'
```

solution: enable useLocalServer and use git's ssh command
```json
{
    "remote.SSH.useLocalServer": true,
    "remote.SSH.path": "D:\\Program Files\\Git\\usr\\bin\\ssh.exe",
}
```
