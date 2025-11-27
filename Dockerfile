FROM alpine:edge

ARG AUUID="35abede8-ce5e-4d04-a378-f6f73fb40f59"
ARG CADDYIndexPage="https://github.com/AYJCSGM/mikutap/archive/master.zip"
ARG ParameterSSENCYPT="chacha20-ietf-poly1305"
ARG PORT=80

ADD etc/Caddyfile /tmp/Caddyfile
ADD etc/xray.json /tmp/xray.json
ADD start.sh /start.sh

# 分步骤执行，便于定位错误
RUN echo "步骤1: 更新包管理器并安装依赖..." && \
    apk update && \
    apk add --no-cache ca-certificates caddy tor wget unzip

RUN echo "步骤2: 下载并安装 Xray..." && \
    wget -O Xray-linux-64.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip -o Xray-linux-64.zip && \
    chmod +x xray && \
    mv xray /xray && \
    rm -f Xray-linux-64.zip

RUN echo "步骤3: 创建目录结构..." && \
    mkdir -p /etc/caddy/ /usr/share/caddy && \
    echo -e "User-agent: *\nDisallow: /" >/usr/share/caddy/robots.txt

RUN echo "步骤4: 下载并解压网站文件..." && \
    wget "$CADDYIndexPage" -O /tmp/site.zip && \
    unzip -qo /tmp/site.zip -d /tmp/site_temp/ && \
    find /tmp/site_temp/ -name "*.html" -exec mv {} /usr/share/caddy/ \; 2>/dev/null || true && \
    rm -rf /tmp/site_temp/ /tmp/site.zip

RUN echo "步骤5: 处理 Caddyfile 配置..." && \
    CADDY_HASH=$(caddy hash-password --plaintext "$AUUID") && \
    sed -e "1c :$PORT" \
        -e "s/\$AUUID/$AUUID/g" \
        -e "s/\$MYUUID-HASH/$CADDY_HASH/g" \
        /tmp/Caddyfile > /etc/caddy/Caddyfile

RUN echo "步骤6: 处理 Xray 配置..." && \
    sed -e "s/\$AUUID/$AUUID/g" \
        -e "s/\$ParameterSSENCYPT/$ParameterSSENCYPT/g" \
        /tmp/xray.json > /xray.json

RUN echo "步骤7: 设置启动脚本权限..." && \
    chmod +x /start.sh && \
    rm -rf /var/cache/apk/*

CMD /start.sh
