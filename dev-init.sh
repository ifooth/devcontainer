#!/bin/bash
# devcontainer init script

if [ -n $GIT_USER_NAME ]
    git config --global user.name $GIT_USER_NAME
fi

if [ -n $GIT_USER_EMAIL ]
    git config --global user.email $GIT_USER_NAME
fi

if [ -n $GIT_USER_SIGNINGKEY ]
    git config --global user.signingkey $GIT_USER_SIGNINGKEY
    git config --global commit.gpgsign true
fi

git config --global credential.helper store
git config --global pull.ff only
