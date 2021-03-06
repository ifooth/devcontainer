# DevContainer
Full stack remote development environment

[![Docker](https://github.com/ifooth/devcontainer/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/ifooth/devcontainer/actions/workflows/docker-publish.yml)
[![Docker Pulls](https://img.shields.io/docker/pulls/ifooth/devcontainer.svg)](https://hub.docker.com/r/ifooth/devcontainer/)

Base on [vscode-dev-containers](https://github.com/microsoft/vscode-dev-containers) image

## Shell
- [zsh](https://www.zsh.org/)
- [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
- [git](http://git-scm.com/) - A distributed version control system
- [fzf](https://github.com/junegunn/fzf) - A command-line fuzzy finder
- [autojump](https://github.com/wting/autojump) - A cd command that learns - easily navigate directories from the command line
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [direnv](https://github.com/direnv/direnv) - unclutter your .profile, set env by dir automate

## Vim
Plugin
- [nerdtree](https://github.com/scrooloose/nerdtree.git)
- [ctrlp.vim](https://github.com/kien/ctrlp.vim.git)
- [vim-easymotion](https://github.com/easymotion/vim-easymotion.git)
- [ag.vim](https://github.com/rking/ag.vim.git)
- [vim-airline](https://github.com/vim-airline/vim-airline)
- [vim-airline-themes](https://github.com/vim-airline/vim-airline-themes)
- [vim-colors-solarized.git](https://github.com/altercation/vim-colors-solarized.git)
- [nerdcommenter](https://github.com/scrooloose/nerdcommenter)

## Python
- [pyenv](https://github.com/pyenv/pyenv)

usage
```shell
# switch python version
pyenv versions
export PYENV_VERSION=3.10

# use virtualenv, use the linked major version
mkvirtualenv -p /opt/pyenv/versions/3.10/bin/python hello-world
workon hello-world
```

.envrc
```bash
layout virtualenvwrapper hello-world
unset PS1
```

.vscode/settings.json
```json
{
    "python.defaultInterpreterPath": "~/.virtualenvs/hello-world/bin/python"
}
```

## Golang
- [gvm](https://github.com/moovweb/gvm)

usage
```shell
# switch golang version
gvm list
gvm use go1.18
```

.envrc
```bash
layout gvm go1.18
```

.vscode/settings.json
```json
{
    "go.goroot": "/opt/gvm/gos/go1.18",
    "go.gopath": "/opt/gvm/pkgsets/go1.18/global"
}
```

golang private mod settings

.vscode/settings.json

```json
{
    "go.goroot": "/opt/gvm/gos/go1.15",
    "go.gopath": "/opt/gvm/pkgsets/go1.15/global",
    "go.toolsEnvVars": {
        "GOPROXY": "https://athens-proxy.townsy.io,direct",
        "GOPRIVATE": "",
        "GONOSUMDB": "townsy.private-github.com"
    },
    "terminal.integrated.env.linux": {
        "GOPROXY": "https://athens-proxy.townsy.io,direct",
        "GOPRIVATE": "",
        "GONOSUMDB": "townsy.private-github.com"
    }
}
```

## Build linux kernel

build the linux kernel in the devcontainer, all tools has been installed

```bash
mkdir /data/kernel && cd /data/kernel
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.16.17.tar.xz # change version as you need
tar -xf linux-5.16.17.tar.xz
cd linux-5.16.17
make menuconfig # change config
make -j 10
```


## Utils
- [cloc](https://github.com/AlDanial/cloc) - counts blank lines, comment lines, and physical lines of source code in many programming languages
- [restic](https://github.com/restic/restic) - Fast, secure, efficient backup program
- [rclone](https://github.com/rclone/rclone) - rsync for cloud storage
- [android-platform-tools](https://developer.android.com/studio/releases/platform-tools) - such as adb, fastboot, and systrace tools


## Settings
install-extension

```json
{
    "remote.extensionKind": {
        "alefragnani.project-manager": [
            "workspace"
        ]
    },
    "remote.SSH.defaultExtensions": [
        "ms-python.python",
        "ms-python.vscode-pylance",
        "golang.go",
        "TabNine.tabnine-vscode",
        "alefragnani.project-manager"
    ]
}
```

vscode remote ssh settings

~/.vscode-server/data/Machine/settings.json

use the linked major version

```json
{
    "go.goroot": "/opt/gvm/gos/go1.18",
    "go.gopath": "/opt/gvm/pkgsets/go1.18/global",
    "go.toolsEnvVars": {
        "GOBIN": "/opt/go/bin"
    },
    "python.linting.flake8Path": "/usr/local/bin/flake8",
    "python.linting.flake8Args": [
        "--max-line-length=119"
    ],
    "python.formatting.blackPath": "/usr/local/bin/black",
    "python.formatting.blackArgs": [
        "--line-length=119"
    ],
    "python.sortImports.path": "/usr/local/bin/isort",
    "python.sortImports.args": [
        "--line-length=119"
    ],
    "python.terminal.activateEnvironment": false,
    "git.ignoredRepositories": [
        "/opt/pyenv"
    ],
    "projectManager.groupList": true,
    "projectManager.git.maxDepthRecursion": 4,
    "projectManager.git.baseFolders": [
        "/data/repos"
    ]
}
```


## Tips and Tricks

### windows remote ssh cann't connection with zsh

error log:
```bash
zsh: bad math expression: operand expected at `*100000 + ...'
```

solution: enable useLocalServer
```json
{
    "remote.SSH.useLocalServer": true
}
```

maybe have [non-Windows SSH installed](https://github.com/microsoft/vscode-remote-release/issues/2525) issue, just ignore
