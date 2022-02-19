if [[ "$BOOTSTRAP" == "1" ]];then
    return 0
fi

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export PATH=/data/bin:/opt/go/bin:/opt/pyenv/bin:/opt/pyenv/shims:$PATH

# ssh
if [ ! -d "${HOME}/.ssh" ];then
    mkdir -p ${HOME}/.ssh
    touch ${HOME}/.ssh/config
fi

# vim
export VIM_ROOT=/opt/vim

# gvm
export GVM_ROOT=/opt/gvm
if [ ! -d "${HOME}/.gvm" ];then
    mkdir -p ${HOME}/.gvm
    tar -xvf ${GVM_ROOT}/pkgsets.tar.gz -C ${HOME}/.gvm
fi

if [ ! -L ${GVM_ROOT}/pkgsets ] || [ ! -e ${GVM_ROOT}/pkgsets ];then
    rm -rf ${GVM_ROOT}/pkgsets
    ln -sf ${HOME}/.gvm/pkgsets ${GVM_ROOT}
fi

[[ -s "/opt/gvm/scripts/gvm" ]] && source "/opt/gvm/scripts/gvm"
gvm use go1.17.6 > /dev/null 2>&1

# pyenv
export PYENV_ROOT=/opt/pyenv
export PYENV_PKG=versions/3.10.1/lib/python3.10/site-packages
if [ ! -d "${HOME}/.pyenv/${PYENV_PKG}" ];then
    mkdir -p ${HOME}/.pyenv
    tar -xvf ${PYENV_ROOT}/versions.tar.gz -C ${HOME}/.pyenv
fi

if [ ! -L ${PYENV_ROOT}/${PYENV_PKG} ] || [ ! -e ${PYENV_ROOT}/${PYENV_PKG} ];then
    rm -rf ${PYENV_ROOT}/${PYENV_PKG}
    ln -sf ${HOME}/.pyenv/${PYENV_PKG} ${PYENV_ROOT}/${PYENV_PKG}
fi

if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
    pyenv virtualenvwrapper
fi
export PYENV_VERSION=3.10.1

# virtualenvwrapper
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
source /usr/local/bin/virtualenvwrapper.sh

# 可使用这个变量, 防止重复source
export BOOTSTRAP="1"
