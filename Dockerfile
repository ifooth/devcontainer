FROM mcr.microsoft.com/vscode/devcontainers/python:3.10

COPY *.sh /usr/local/bin/

# 安装依赖包
RUN /usr/local/bin/install-pkg.sh

COPY root/* /root/

# 安装开发环境
RUN /usr/local/bin/install-virtualenv.sh && \
    mkdir -p /data/repos /data/bin /data/logs

ADD ./supervisord.conf /etc/supervisord.conf

# 代码/数据目录
VOLUME [ "/data" ]

WORKDIR /data/repos

CMD ["docker-entrypoint.sh"]
