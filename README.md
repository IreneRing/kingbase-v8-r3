# 人大金仓数据库管理系统（KingbaseES V8 R3) Docker 镜像

分享将人大金仓数据库封装Docker镜像方法

使用的人大金仓版本号：V008R003C002B0320


## 目录结构

```
tree ./ -L 1

./
├── build.sh
├── Dockerfile
├── entrypoint.sh
├── initdb.sh
├── kingbase.tar.gz
├── license.dat
├── password
└── README.md

0 directories, 8 files
```

## 拉取镜像 (直接使用上传仓库的镜像)

## Dockerhub

```bash
docker pull haloking/kingbase:v8r3
```
## Github

```bash
docker pull ghcr.io/eazonziu/kingbase:v8r3
```

## 构建镜像

如果您想自己构建镜像可参照以下操作：

```bash
git clone https://github.com/EazonZiu/kingbase-v8-r3.git
cd kingbase-v8-r3
sh build.sh
```

## 运行 (复制service.sh到自己指定目录)

```bash
sh service.sh
```

## 运行 (命令)

```bash
docker run -d --name kingbase-v8r3 -p 54321:54321 \
        -e SYSTEM_USER=kingbase -e SYSTEM_PWD=qwe123 \
        -v $(pwd)/volumes/opt/data:/opt/kingbase/data \
        -v $(pwd)/volumes/opt/license.dat:/opt/kingbase/Server/bin/license.dat \
        --restart=always  kingbase:v8r3
```

- --name: 容器名称
- -p: 端口映射
- -e SYSTEM_USER: 默认用户SYSTEM,当前修改用户
- -e SYSTEM_PWD:  默认密码SYSTEM,当前修改密码
- -v: 挂载宿主机的一个目录，这里挂载了数据目录和license文件
- $(pwd): 命令执行当前地址

## 启动日志

```bash
The files belonging to this database system will be owned by user "kingbase".
This user must also own the server process.

The database cluster will be initialized with locale "C".
The default text search configuration will be set to "english".

Data page checksums are disabled.

The comparision of strings is case-insensitive.
fixing permissions on existing directory /opt/kingbase/data ... ok
creating subdirectories ... ok
selecting default max_connections ... 100
selecting default shared_buffers ... 128MB
selecting dynamic shared memory implementation ... posix
creating configuration files ... ok
running bootstrap script ... ok
performing post-bootstrap initialization ... ok
create samples database ... ok
loading samples database ... ok
loading template2 database ... ok
create security database ... ok
load security database ... ok
syncing data to disk ... ok

Success. You can now start the database server using:

    ./sys_ctl -D /opt/kingbase/data -l logfile start

server starting
LOG:  redirecting log output to logging collector process
HINT:  Future log output will appear in directory "sys_log".
```

## 连接kingbase8的test数据库(针对使用上面创建容器名字)

```bash
sh conn.sh
```

## kingbase8 - jdbc

```bash
jdbc:kingbase8://ip:host/datasource
```

注意 ``` license.dat ``` 使用到是企业版，会有限期；使用下载的镜像可以重新挂载自己的，或者修改当前目录的重新构建新镜像

注意 ``` 启动容器后 ``` ，无法使用有数据的挂载目录情况下 ``` 修改用户或密码 ``` ，重新启动还是原来的用户和密码


## 常见问题
### 启动失败
- 启动失败，日志报 kingbase: superuser_reserved_connections must be less than max_connections
- 原因：本仓库中的 license.dat 文件是开发测试版，限制最大连接数为10，而人大金仓配置文件默认连接数为100，导致启动失败。
- 解决：修改数据目录下的 kingbase.conf 配置文件

 ```bash
 max_connect = 10
 superuser_reserved_connections = 5 #小于max_connect
 super_manager_reserved_connections = 3  #小于superuser_reserved_connections
 ```
### FATAL: lock file kingbase.pid already exists
- 提示：FATAL: lock file kingbase.pid already exists。是因为 docker 容器被关闭了数据库还没来得及停机，我们去数据目录下把 kingbase.pid 文件删除掉即可，数据目录就是上面映射本机目录的，我的教程里是在 /opt/kingbase/data/。

## 参考工程：

[https://github.com/chyidl/kingbase-es-v8-r6-docker](https://github.com/chyidl/kingbase-es-v8-r6-docker)

[https://github.com/renfei/kingbase-es-v8-r3-docker](https://github.com/renfei/kingbase-es-v8-r3-docker)
