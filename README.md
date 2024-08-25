# 构建docker镜像

paperspace中可以使用自己构建的镜像

注意： 推送之前要在 ![aliyun 镜像仓库](https://cr.console.aliyun.com/cn-hangzhou/instance/repositories) 中创建 paperspace 仓库

```
docker build -t paperspace:v2 -f Dockerfile . --platform=linux/amd64
docker login --username=windyuan99 registry.cn-hangzhou.aliyuncs.com
docker tag paperspace:v2 registry.cn-hangzhou.aliyuncs.com/yywind/paperspace:v2
docker push registry.cn-hangzhou.aliyuncs.com/yywind/paperspace:v2
```

# 可以用 yunpan
