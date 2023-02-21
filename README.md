## 镜像版本

Docker 镜像分为 **精简版** 和 **扩展版**，精简版仅有云崽本体（可选加载喵喵插件和图鉴插件），扩展版附带 ffmpeg 环境和 Python 环境（可选加载 Python 插件）。

若需要运行 python 插件或语音相关插件，请使用扩展版镜像。

国内机器请选择位于华为云的镜像，海外机器可选位于 DockerHub 的镜像。

**扩展版**

- **华为云**: `swr.cn-south-1.myhuaweicloud.com/sirly/yunzai-bot:v3plus`
- **DockerHub**: `sirly/yunzai-bot:v3plus`

**精简版**

- **华为云**: `swr.cn-south-1.myhuaweicloud.com/sirly/yunzai-bot:v3`
- **DockerHub**: `sirly/yunzai-bot:v3`

> 你可以在 [SirlyDreamer/Yunzai-Bot-Docker](https://github.com/SirlyDreamer/Yunzai-Bot-Docker) 的不同分支中找到各对应版本的 Dockerfile。

## 安装 Docker

### 使用一键脚本安装（荐）

```bash
curl -fsSL https://get.docker.com | bash -s - --mirror Aliyun
```

## 准备项目

### 辅助脚本（荐）

Linux 可使用一键辅助脚本创建所需文件夹并下载所需文件，并可选择是否安装喵喵插件、图鉴插件和 Python 插件。

```bash
bash <(curl -sSL http://yunzai.org/install_v3)
```

### 手动部署

将本项目克隆到本地

```bash
git clone https://github.com/SirlyDreamer/Yunzai-Bot-Docker.git yunzai-bot
cd Yunzai-Bot-Docker
```

按照注释修改 `docker-compose.yaml` 中的内容

```bash
vim docker-compose.yaml
```

Tips: vim 可以使用`:wq`退出并保存文件，不要使用 `Ctrl + S` ，这样会导致终端挂起，如果您不小心按下了 `Ctrl + S` 组合键，您可以按下 `Ctrl + Q` 组合键来解除屏幕暂停并继续输入。

## 运行项目

使用 `cd yunzai-bot` 进入工作目录。

### 首次运行

首次运行如果 QQ 登录需要验证或者扫码登录，请按以下步骤进行操作。

1. **启动容器**

    在工作目录内运行命令，拉起容器，并运行初始化命令。

    ```bash
    docker compose up -d
    docker exec -it yunzai-bot node app
    ```

2. **完成验证，重启容器**

    验证完成后，按快捷键 Ctrl+C 退出，然后重启容器

    ```bash
    docker compose restart
    ```

## 常用命令

- **后台运行**

    ```bash
    docker compose up -d
    ```

- **前台运行**

    ```bash
    docker compose up
    ```

- **停止运行**

    ```bash
    docker compose down
    ```

- **重启/更新**

    重启时会自动拉取最新项目并更新相关依赖

    ```bash
    docker compose restart
    ```

- **查看日志**

    查看最后的 100 行日志并持续输出日志

    ```bash
    docker compose logs -f --tail=100
    ```

## 安装插件

### 单 js 文件插件的安装

1. **映射目录并创建本地文件夹**

	> 若您使用辅助部署脚本完成了 docker 配置，请忽略本条。

    在 `docker-compose.yaml` 文件中映射插件目录 `./yunzai/plugins/example:/app/Yunzai-Bot/example`。
   
    ```yaml {12}
    version: "3.9"
    services:
      yunzai-bot:
        container_name: yunzai-bot
        image: sirly/yunzai-bot:v3
        restart: always
        volumes:
          - ./yunzai/config:/app/Yunzai-Bot/config/config/ # 配置文件
          - ./yunzai/genshin_config:/app/Yunzai-Bot/plugins/genshin/config    # 配置文件
          - ./yunzai/logs:/app/Yunzai-Bot/logs # 日志文件
          - ./yunzai/data:/app/Yunzai-Bot/data # 数据文件
          - ./yunzai/plugins/example:/app/Yunzai-Bot/example # js 插件
    ```
   
    创建本地文件夹 `./yunzai/plugins/example`。
   
    > 使用 `docker-compose up -d` 重新部署容器以应用配置文件更新

2. **安装插件**

    > 建议您在该过程中用另一个命令行窗口，运行 `docker-compose logs -f --tail=50` 打开日志滚动，通过日志观察插件安装是否成功，并测试是否能够正常运行。

    将 js 插件置于本地目录 `./yunzai/plugins/example` 中，即可完成安装，无需重启容器，此时容器日志能够看到提示 `插件 XXX 更新成功`。

### 大型扩展插件的安装

1. **安装插件**


>    使用辅助部署脚本，可选择自动安装 Miao-Plugin、xiaoyao-cvs-plugin 和 py-plugin。如果还需要其他插件，请遵循以下指南进行安装。


    进入本地插件目录 `./yunzai/plugins`，使用 `git clone 插件仓库地址` 下载插件。
    
    详细安装方法和注意事项请参阅对应插件的说明文档，只需将说明文档中提到的 `plugins` 目录换成主机的 `plugins` 目录对应路径即可。

2. **映射目录**

    在 `docker-compose.yaml` 文件中映射插件目录 `./yunzai/plugins/xxxx:/app/Yunzai-Bot/plugins/xxxx`，每个插件都要映射，例如：

```yaml {14-16}
    version: "3.9"
    services:
      yunzai-bot:
        container_name: yunzai-bot
        image: sirly/yunzai-bot:v3
        restart: always
        volumes:
          - ./yunzai/config:/app/Yunzai-Bot/config/config/ # 配置文件
          - ./yunzai/genshin_config:/app/Yunzai-Bot/plugins/genshin/config    # 配置文件
          - ./yunzai/logs:/app/Yunzai-Bot/logs # 日志文件
          - ./yunzai/data:/app/Yunzai-Bot/data # 数据文件
          - ./yunzai/plugins/example:/app/Yunzai-Bot/example # js 插件
          # 以下目录是插件目录，安装完插件后需要手动添加映射
          - ./yunzai/plugins/miao-plugin:/app/Yunzai-Bot/plugins/miao-plugin                  # 喵喵插件
          - ./yunzai/plugins/py-plugin:/app/Yunzai-Bot/plugins/py-plugin                      # 新py插件
          - ./yunzai/plugins/xiaoyao-cvs-plugin:/app/Yunzai-Bot/plugins/xiaoyao-cvs-plugin    # 图鉴插件
        ports:
          - 50831:50831                                                                       # 锅巴插件映射端口(可删除)
              # 省略后续配置...
```


3.**使用脚本重新加载配置**

如果你的Docker已经运行，并且在创建容器后更改了如 `docker-compose.yaml`等配置,需要用以下代码重新部署容器

```bash
docker-compose up -d
```

