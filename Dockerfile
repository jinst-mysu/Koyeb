FROM alpine:edge

ARG AUUID="获取一个UUID替换此处"
ARG CADDYIndexPage="https://github.com/AYJCSGM/mikutap/archive/master.zip"
ARG ParameterSSENCYPT="chacha20-ietf-poly1305"
ARG PORT=80

ADD etc/Caddyfile /tmp/Caddyfile
ADD etc/xray.json /tmp/xray.json
ADD start.sh /start.sh

# 安装依赖
RUN apk update && \
    apk add --no-cache ca-certificates caddy tor wget unzip

# 下载安装 Xray
RUN wget -O Xray-linux-64.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip -o Xray-linux-64.zip && \
    chmod +x xray && \
    mv xray /xray && \
    rm -f Xray-linux-64.zip

# 创建目录和文件
RUN mkdir -p /etc/caddy/ /usr/share/caddy && \
    echo -e "User-agent: *\nDisallow: /" >/usr/share/caddy/robots.txt

# 下载网站文件
RUN wget "$CADDYIndexPage" -O /tmp/site.zip && \
    unzip -qo /tmp/site.zip -d /tmp/site_temp/ && \
    find /tmp/site_temp/ -name "*.html" -exec mv {} /usr/share/caddy/ \; 2>/dev/null || true && \
    rm -rf /tmp/site_temp/ /tmp/site.zip

# 处理 Caddyfile - 使用 | 作为分隔符避免冲突
RUN CADDY_HASH=$(caddy hash-password --plaintext "$AUUID") && \
    sed -e "1c :$PORT" \
        -e "s|\$AUUID|$AUUID|g" \
        -e "s|\$MYUUID-HASH|$CADDY_HASH|g" \
        /tmp/Caddyfile > /etc/caddy/Caddyfile

# 处理 xray.json
RUN sed -e "s|\$AUUID|$AUUID|g" \
        -e "s|\$ParameterSSENCYPT|$ParameterSSENCYPT|g" \
        /tmp/xray.json > /xray.json

RUN chmod +x /start.sh && \
    rm -rf /var/cache/apk/*

CMD /start.sh
