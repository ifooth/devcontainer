#!/bin/bash
# devcontainer init script example

git config --global user.name ""
git config --global user.email ""

git config --global user.signingkey ""
git config --global credential.helper store
git config --global commit.gpgsign true
git config --global pull.ff only
