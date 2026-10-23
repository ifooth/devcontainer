# DevContainer

Full stack remote development environment

[![lint](https://github.com/ifooth/devcontainer/actions/workflows/lint.yml/badge.svg?branch=main)](http://github.com/ifooth/devcontainer/actions/workflows/lint.yml)
[![build](https://github.com/ifooth/devcontainer/actions/workflows/build.yml/badge.svg?branch=main)](http://github.com/ifooth/devcontainer/actions/workflows/build.yml)
[![Docker](https://github.com/ifooth/devcontainer/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/ifooth/devcontainer/actions/workflows/docker-publish.yml)
[![Docker Pulls](https://img.shields.io/docker/pulls/ifooth/devcontainer.svg)](https://hub.docker.com/r/ifooth/devcontainer/)

Base on [devcontainers/base](https://github.com/devcontainers/images/tree/main) image

## Shell

- [zsh](https://www.zsh.org/)
- [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
- [git](http://git-scm.com/) - A distributed version control system
- [gh](https://github.com/cli/cli) - GitHub’s official command line tool
- [fzf](https://github.com/junegunn/fzf) - A command-line fuzzy finder
- [zoxide](https://github.com/ajeetdsouza/zoxide) - A smarter cd command. Supports all major shells.
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
- [vim-monokai](https://github.com/sickill/vim-monokai)
- [onedark.vim](https://github.com/joshdick/onedark.vim)

## tools

- [scc](https://github.com/boyter/scc) - scc is a very fast accurate code counter with complexity calculations and COCOMO estimates written in pure Go
- [kopia](https://github.com/kopia/kopia) - Fast and secure open-source backup software
- [rclone](https://github.com/rclone/rclone) - rsync for cloud storage
- [protoc](https://github.com/protocolbuffers/protobuf) - Protocol Buffers - Google's data interchange format
- [grpcurl](https://github.com/fullstorydev/grpcurl) - Like cURL, but for gRPC
- [nodejs](https://nodejs.org/) - JavaScript runtime
- [docker cli](https://docs.docker.com/reference/cli/docker/) - Docker command line
- [ripgrep](https://github.com/BurntSushi/ripgrep) - Recursively search directories for a regex pattern

## Dev.env

- set pre / post script
- set git config
- dev server / jupyter lab
- set tz and so on

```bash
# 前后置脚本
PRE_SCRIPT_FILE=""
POST_SCRIPT_FILE=""

# git 配置
GIT_USER_NAME=""
GIT_USER_EMAIL=""
GIT_USER_SIGNINGKEY=""

# dev server 配置
DEV_SERVER_PORT="8022"

# jupyter lab 配置
JUPYTER_PORT="8088"
JUPYTER_TOKEN="devcontainer"
JUPYTER_NOTEBOOK_DIR="/data/repos/jupyter-notebook"

# 时区配置
TZ=Asia/Shanghai
```

Container starts sshd, `dev server`, and JupyterLab via supervisord.

- sshd: `SSHD_PORT`, default `36022`
- dev server: `DEV_SERVER_PORT`, default `8022`. File browser at `/file/browser`, terminal preview at `/terminal/preview`
- JupyterLab: notebook dir `JUPYTER_NOTEBOOK_DIR`, token `JUPYTER_TOKEN`. The image venv is `/opt/python/notebook`

## Python toolchain

Image ships Python 3.14.8. `py3` and `py3.14` both point at `/opt/python/py3.14`. JupyterLab lives in `/opt/python/notebook`.

- [uv](https://github.com/astral-sh/uv) - An extremely fast Python package and project manager, written in Rust.
- [ruff](https://github.com/astral-sh/ruff) - An extremely fast Python linter and code formatter, written in Rust.
- [jupyterlab](https://github.com/jupyterlab/jupyterlab) - JupyterLab computational environment.

usage

```shell
# switch python version
uv venv /root/.venv/hello-world -p /opt/python/py3/bin/python
source /root/.venv/hello-world/bin/activate
```

.envrc

```bash
export VIRTUAL_ENV="/root/.venv/hello-world"
layout python
```

.vscode/settings.json

```json
{
    "python.defaultInterpreterPath": "/root/.venv/hello-world/bin/python"
}
```

## Golang toolchain

Image ships Go 1.27.3. `go`, `go1`, and `go1.27` all point at `/opt/go/sdk/go1.27.1`. User `GOPATH` is `/root/.go`.

- [office manage-install](https://go.dev/doc/manage-install)

usage

```shell
# install another golang version
export HOME=/opt/go
go install golang.org/dl/go1.27.3@latest
go1.27.3 download
```

version list in [golang/dl](https://github.com/golang/dl)

.envrc

```bash
# switch golang version
export PATH=/opt/go/sdk/go1/bin:$PATH
```

.vscode/settings.json

```json
{
    "go.goroot": "/opt/go/sdk/go1",
    "go.gopath": "/root/.go"
}
```

golang private mod settings

.vscode/settings.json

```json
{
    "go.goroot": "/opt/go/sdk/go1",
    "go.gopath": "/root/.go",
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

## Develop golang

You can refer to the official guidelines <https://go.dev/doc/contribute>

here is use vscode learn golang src

```bash
# clone go repo
git clone https://github.com/golang/go
cd go

# checkout the version you are interested in
git checkout release-branch.go1.27

# build go bin & pkg tools
cd src && ./make.bash && cd ..

# add `go.work` for src workspace
go work init
# change if you need
# go work edit -go=1.27
go work use src

# modify according to the following configuration
mkdir .vscode && vim .vscode/settings.json
```

add custom `go.goroot` settings

```json
{
    "go.goroot": "/data/repos/golang/go"
}
```

all Go language server work perfect

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

## Settings

auto install-extension

open the user settings editor from the Command Palette (Ctrl+Shift+P) with Preferences: Open User Settings(JSON).

```json
{
    "remote.SSH.useLocalServer": true,
    "remote.SSH.suppressWindowsSshWarning": true,
    "remote.SSH.remotePlatform": {
        "devcontainer": "linux"
    },
    "remote.extensionKind": {
        "alefragnani.project-manager": [
            "workspace"
        ]
    },
    "remote.SSH.defaultExtensions": [
        "golang.go",
        "ms-python.python",
        "charliermarsh.ruff",
        "geddski.macros",
        "alefragnani.project-manager",
        "ms-azuretools.vscode-docker",
        "ms-vscode.makefile-tools",
        "quillaja.goasm",
        "davidanson.vscode-markdownlint",
        "redhat.vscode-yaml",
        "redhat.vscode-xml",
        "xaver.clang-format",
        "zxh404.vscode-proto3",
        "tencent-cloud.coding-copilot"
    ]
}
```

list-extensions

```bash
code --list-extensions --show-version
```

snippets

open the user settings editor from the Command Palette (Ctrl+Shift+P) with Snippets: Open User Snippets.

copy snippet to config, example `go.json`

```json
{
    "import github.com/stretchr/testify/assert": {
        "prefix": "iassert",
        "body": "\"github.com/stretchr/testify/assert\"",
        "description": "Code snippet for import testify assert"
    },
    "import github.com/pkg/errors": {
        "prefix": "ipkgerr",
        "body": "\"github.com/pkg/errors\"",
        "description": "Code snippet for import pkg errors"
    }
}
```

vscode remote ssh settings

~/.vscode-server/data/Machine/settings.json

use the linked major version

```json
{
    "go.goroot": "/opt/go/sdk/go1",
    "go.gopath": "/root/.go",
    "go.toolsEnvVars": {
        "GOBIN": "/opt/go/bin"
    },
    "go.lintTool": "golangci-lint",
    "go.lintFlags": [
        "-c",
        "/etc/.golangci.yml"
    ],
    "clang-format.style": "{IndentWidth: 4, BasedOnStyle: google, AlignConsecutiveAssignments: true, ColumnLimit: 0}",
    "python.linting.flake8Path": "/usr/local/bin/flake8",
    "python.linting.flake8Args": [
        "--max-line-length=119"
    ],
    "python.formatting.blackPath": "/usr/local/bin/black",
    "python.formatting.blackArgs": [
        "--line-length=119"
    ],
    "isort.path": [
        "/usr/local/bin/isort"
    ],
    "isort.args": [
        "--line-length=119"
    ],
    "python.terminal.activateEnvironment": false,
    "git.ignoredRepositories": [
        "/opt/pyenv"
    ],
    "projectManager.groupList": true,
    "projectManager.git.maxDepthRecursion": 4,
    "projectManager.git.ignoredFolders": [
        "code-review",
        "github"
    ],
    "projectManager.git.baseFolders": [
        "/data/repos"
    ],
    "editor.bracketPairColorization.enabled": false
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
