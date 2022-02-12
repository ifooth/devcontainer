#!/bin/bash
set -ex

for extension in ms-python.python \
    ms-python.vscode-pylance \
    golang.go \
    ms-azuretools.vscode-docker \
    TabNine.tabnine-vscode \
    alefragnani.project-manager

    do code --install-extension $extension
done

code --list-extensions
