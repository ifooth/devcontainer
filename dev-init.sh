#!/bin/bash
# devcontainer init script example

git config --global user.name ""
git config --global user.email ""

git config --global user.signingkey ""
git config --global credential.helper store
git config --global commit.gpgsign true
git config --global pull.ff only

export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export RESTIC_REPOSITORY=
export RESTIC_PASSWORD=

# restore gnupg config
rm -rf /tmp/.gnupg && restic restore --host mac --tag gnupg latest -t /tmp
chown -R root:root /tmp/.gnupg && rsync -avz --delete /tmp/.gnupg /root/
rm -rf /tmp/.gnupg

# restore ssh config
rm -rf /tmp/.ssh && restic restore --host mac --tag ssh latest -t /tmp
chown -R root:root /tmp/.ssh && rsync -avz /tmp/.ssh /root/
rm -rf /tmp/.ssh
