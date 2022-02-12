#!/bin/bash
set -ex

code --install-extension \
    ms-python.python \
    ms-python.vscode-pylance \
    golang.go \
    ms-azuretools.vscode-docker \
    TabNine.tabnine-vscode \
    alefragnani.project-manager

code --list-extensions
