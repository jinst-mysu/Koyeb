# 某容器云部署Xray高性能代理

# 请勿使用常用的账号部署此项目，以免封号！！

## 部署步骤

1. fork本仓库
2. 在`Dockerfile`内第3-5行修改自定义设置，说明如下：

AUUID：在[uuidgenerator](https://www.uuidgenerator.net/)生成

MYUUID_HASH：在[MYUUID_HASH](https://33tool.com/bcrypt/)用UUID加密一下

`CADDYIndexPage`：伪装站首页文件

`ParameterSSENCYPT`：ShadowSocks加密协议

3. 去[Docker Hub](https://hub.docker.com/)注册一个账号，如有账号可跳过
   
4. 编辑Actions文件`docker-image.yml`，按照“name: Docker Hub ID/自定义镜像名称”格式修改第13行
<img width="1030" height="607" alt="image" src="https://github.com/user-attachments/assets/91d26c2c-c16d-4669-9251-8265a17ad73d" />


5. 添加Actions的Secrets变量，变量说明如下
`DOCKER_USERNAME`：Docker Hub 的用户名
`DOCKER_PASSWORD`：Docker Hub 登录密码
<img width="1332" height="868" alt="image" src="https://github.com/user-attachments/assets/a78bcae0-bc8e-487b-8b77-cd311ffacc33" />



7. 打开某容器云主页，新建一个应用
   
8. 应用配置如下所示
`Docker Image`：Docker Hub镜像地址
环境变量：`Key`：PORT，`Value`：80

8. 客户端配置如下所示

V2ray

地址：xxx-xxx.koyeb.app 或 CF优选IP
端口：443
默认UUID：UUID
vmess额外id：0
加密：none
传输协议：ws
伪装类型：none
伪装域名：xxx-xxx.koyeb.app
路径：/UUID-vless或/UUID-vmess           vless使用(/自定义UUID码-vless)，vmess使用(/自定义UUID码-vmess)
底层传输安全：tls
SNI:xxx-xxx.koyeb.app
ALPN:H3,H2,HTTP/1.1
跳过证书验证：false
