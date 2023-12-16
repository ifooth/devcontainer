FROM mcr.microsoft.com/devcontainers/base:bookworm

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /root

# 配置文件, 代码/数据目录
VOLUME [ "/root", "/data" ]

COPY install-*.sh /usr/local/bin/

# 配置文件
COPY root /opt/root

# 安装依赖包
RUN /usr/local/bin/install-pkg.sh

# 安装开发环境
RUN /usr/local/bin/install-virtualenv.sh

# 启动命令
ADD ./settings /opt/vscode/settings
ADD ./dev-init.sh /usr/local/bin/
ADD ./docker-entrypoint.sh /usr/local/bin/
ADD ./supervisord.conf /etc/supervisord.conf

CMD ["docker-entrypoint.sh"]
