## 部署步骤

1. fork本仓库
2. 在`Dockerfile`内第3-5行修改自定义设置，说明如下：

   AUUID：在[uuidgenerator](https://www.uuidgenerator.net/)生成

   MYUUID_HASH：在[MYUUID_HASH](https://33tool.com/bcrypt/)用UUID加密一下

    `CADDYIndexPage`：伪装站首页文件

    `ParameterSSENCYPT`：ShadowSocks加密协议

4. 去[Docker Hub](https://hub.docker.com/)注册一个账号，如有账号可跳过
   
5. 编辑Actions文件`docker-image.yml`，按照“name: Docker Hub ID/自定义镜像名称”格式修改第13行
   <img width="1030" height="607" alt="image" src="https://github.com/user-attachments/assets/91d26c2c-c16d-4669-9251-8265a17ad73d" />


6. 添加Actions的Secrets变量，变量说明如下
   `DOCKER_USERNAME`：Docker Hub 的用户名
   `DOCKER_PASSWORD`：Docker Hub 登录密码
   <img width="1332" height="868" alt="image" src="https://github.com/user-attachments/assets/a78bcae0-bc8e-487b-8b77-cd311ffacc33" />



7. 打开某容器云主页，新建一个应用
   
8. 应用配置如下所示
   `Docker Image`：Docker Hub镜像地址
   环境变量：`Key`：PORT，`Value`：80

8. V2ray客户端配置如下所示
   <img width="886" height="942" alt="屏幕截图 2025-11-28 095057" src="https://github.com/user-attachments/assets/3a8f9113-65ed-4fd3-bad0-b05aaaf44cdc" />
