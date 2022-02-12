FROM mcr.microsoft.com/vscode/devcontainers/python:3.10

WORKDIR /root

COPY install-*.sh /usr/local/bin/

# 安装依赖包
RUN /usr/local/bin/install-pkg.sh

# 配置文件
COPY root/* /root/

# 安装开发环境
RUN /usr/local/bin/install-virtualenv.sh && \
    mkdir -p /data/repos /data/bin /data/logs

# 启动命令
ADD ./settings /etc/vscode-settings
ADD ./docker-entrypoint.sh /usr/local/bin/
ADD ./supervisord.conf /etc/supervisord.conf

# 代码/数据目录
VOLUME [ "/data" ]

CMD ["docker-entrypoint.sh"]
