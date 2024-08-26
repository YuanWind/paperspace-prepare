# 构建docker镜像

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
