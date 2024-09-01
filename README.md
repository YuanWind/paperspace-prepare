# 构建docker镜像
## 国外环境
可以使用 github 的codespace功能，每个月免费使用120核心小时
1. 点击链接 https://github.com/codespaces 创建一个空的项目, 注意申请4核的版本，镜像比较大的话，2核的撑不住
2. 参考如下命令：
```
# 修改docker 镜像的默认存储位置到/tmp文件夹（可用40G）下，因为给的根目录可用空间可能不足。

sudo du -hd 1 /var/lib/docker
mkdir /tmp/docker
sudo mv /var/lib/docker/tmp /tmp/docker/tmp
sudo ln -s /tmp/docker/tmp /var/lib/docker/tmp
sudo mv /var/lib/docker/image /tmp/docker/image
sudo ln -s /tmp/docker/image /var/lib/docker/image
sudo mv /var/lib/docker/overlay2 /tmp/docker/overlay2
sudo ln -s /tmp/docker/overlay2 /var/lib/docker/overlay2

# 构建镜像并推送docker.io
docker build -t paperspace:121.21.auto -f Dockerfile . --platform=linux/amd64
docker login --username=wind999
docker tag paperspace:121.21.auto docker.io/wind999/paperspace:121.21.auto.v1
docker push docker.io/wind999/paperspace:121.21.auto

# 构建镜像并推送aliyun
docker login --username=windyuan99 registry.cn-hangzhou.aliyuncs.com
docker tag paperspace:121.21.vscode.forge registry.cn-hangzhou.aliyuncs.com/yywind/paperspace:121.21.vscode.forge
docker push registry.cn-hangzhou.aliyuncs.com/yywind/paperspace:121.21.vscode.forge


```
## 版本记录
`docker.io/wind999/paperspace:v7`  cuda121 + torch2.1 + vscode  
`docker.io/wind999/paperspace:v8`  cuda121 + torch2.1 + jupyter  
`registry.cn-hangzhou.aliyuncs.com/yywind/paperspace:v9`  cuda121 + torch2.1 + vscode + miniconda  
`registry.cn-hangzhou.aliyuncs.com/yywind/paperspace:121.21.vscode.forge`  cuda121 + torch2.1 + vscode + miniforge  
`registry.cn-hangzhou.aliyuncs.com/yywind/paperspace:121.21.auto`  cuda121 + torch2.1 + auto(jupyter or vscode)  
`docker.io/wind999/paperspace:121.21.auto`  cuda121 + torch2.1 + auto(jupyter or vscode)  


# hf-hub 功能
参考 https://huggingface.co/docs/huggingface_hub/main/en/guides/upload

# 可以用 yunpan
云盘包括阿里云盘和天翼云盘，参考：https://github.com/tickstep
- 阿里云盘，输入`alipan`进入
- 天翼云盘，输入`cloudpan`进入
