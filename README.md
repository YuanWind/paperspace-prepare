# 构建docker镜像
## 国外环境
可以使用 github 的codespace功能，每个月免费使用120核心小时
1. 点击链接 https://github.com/codespaces 创建一个空的项目, 注意申请4核的版本，镜像比较大的话，2核的撑不住
2. 参考如下命令：
```
# 修改docker 镜像的默认存储位置到/tmp文件夹（可用40G）下，因为给的根目录可用空间可能不足。
cd /tmp
git clone https://github.com/YuanWind/paperspace-prepare.git
cd paperspace-prepare
ln -s /tmp/paperspace-prepare /workspaces/paperspace-prepare

sudo du -hd 1 /var/lib/docker
mkdir /tmp/docker
sudo mv /var/lib/docker/tmp /tmp/docker/tmp
sudo ln -s /tmp/docker/tmp /var/lib/docker/tmp
sudo mv /var/lib/docker/image /tmp/docker/image
sudo ln -s /tmp/docker/image /var/lib/docker/image
sudo mv /var/lib/docker/overlay2 /tmp/docker/overlay2
sudo ln -s /tmp/docker/overlay2 /var/lib/docker/overlay2

# 构建镜像并推送
docker build -t paperspace:v7 -f Dockerfile . --platform=linux/amd64
docker login --username=wind999
docker push wind999/paperspace:v7
```

## 国内环境
paperspace中可以使用自己构建的镜像，可以选择使用vscode
v2使用jupyter
v3以后使用vscode
注意： 推送之前要在 ![aliyun 镜像仓库](https://cr.console.aliyun.com/cn-hangzhou/instance/repositories) 中创建 paperspace 仓库

```
docker build -t paperspace:v2 -f Dockerfile . --platform=linux/amd64
docker login --username=windyuan99 registry.cn-hangzhou.aliyuncs.com
docker tag paperspace:v2 registry.cn-hangzhou.aliyuncs.com/yywind/paperspace:v2
docker push registry.cn-hangzhou.aliyuncs.com/yywind/paperspace:v2
```

Dockerfile: v4 中实现如下功能：
- 安装vscode转发到8888端口
- 集成阿里云盘和电信网盘
- hf下载脚本，可以直接运行 `hfd <repo_name> --local-dir '/tmp/<repo_name>`
- hf-cli 功能

# hf-hub 功能
参考 https://huggingface.co/docs/huggingface_hub/main/en/guides/upload

# 可以用 yunpan
云盘包括阿里云盘和天翼云盘，参考：https://github.com/tickstep
- 阿里云盘，输入`alipan`进入
- 天翼云盘，输入`cloudpan`进入
