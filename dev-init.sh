#!/bin/bash
# devcontainer init script

if [ -n "$GIT_USER_NAME" ];then
    git config --global user.name $GIT_USER_NAME
fi

if [ -n "$GIT_USER_EMAIL" ];then
    git config --global user.email $GIT_USER_EMAIL
fi

if [ -n "$GIT_USER_SIGNINGKEY" ];then
    git config --global user.signingkey $GIT_USER_SIGNINGKEY
    git config --global commit.gpgsign true
else
    git config --global --unset user.signingkey
    git config --global commit.gpgsign false
fi

git config --global credential.helper store
git config --global pull.ff only
