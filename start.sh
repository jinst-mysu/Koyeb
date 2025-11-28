#!/bin/sh

# 设置环境变量
export AUUID=获取的UUID替换此处
export MYUUID_HASH=（UUID通过Bcrypt加密得到的结果替换此处，包括括号$2a$14$h7.UEfTJ7cmXz.Tq8U9JrubRaaXZP4PwGDfuPH9Cd7G8oYKv1s.8.）
export PORT=80

echo "=== 环境变量 ==="
echo "AUUID: $AUUID"
echo "PORT: $PORT"

# 创建静态配置（不使用环境变量）
cat > /etc/caddy/Caddyfile << EOC
:80
root * /usr/share/caddy
file_server browse

header {
    X-Robots-Tag none
    X-Content-Type-Options nosniff
    X-Frame-Options DENY
    Referrer-Policy no-referrer-when-downgrade
}

@websocket_xray_vmess {
    header Connection *Upgrade*
    header Upgrade    websocket
    path /35abede8-ce5e-4d04-a378-f6f73fb40f59-vmess
}
reverse_proxy @websocket_xray_vmess 127.0.0.1:10001
EOC

cat > /xray.json << EOX
{
  "log": {
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "port": 10001,
      "listen": "127.0.0.1",
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "35abede8-ce5e-4d04-a378-f6f73fb40f59",
            "level": 0,
            "alterId": 0
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "/35abede8-ce5e-4d04-a378-f6f73fb40f59-vmess"
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    }
  ]
}
EOX

echo "=== 启动 Xray ==="
/xray run -config /xray.json &

echo "等待 Xray 启动..."
sleep 5

echo "=== 启动 Caddy ==="
exec caddy run --config /etc/caddy/Caddyfile
