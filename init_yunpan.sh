# 天翼云盘
mkdir -p ~/software
cd ~/software
# https://github.com/tickstep/cloudpan189-go/releases
wget https://github.com/tickstep/cloudpan189-go/releases/download/v0.1.3/cloudpan189-go-v0.1.3-linux-386.zip
unzip cloudpan189-go-v0.1.3-linux-386.zip
echo "alias cloudpan='~/software/cloudpan189-go-v0.1.3-linux-386/cloudpan189-go'" >> ~/.zshrc && source ~/.zshrc

# login登录后，输入 family ，然后选择1切换到家庭云
# 帮助文档： https://github.com/tickstep/cloudpan189-go/blob/master/docs/manual.md#%E5%88%87%E6%8D%A2%E4%BA%91%E5%B7%A5%E4%BD%9C%E6%A8%A1%E5%BC%8F


# 阿里云盘
wget https://github.com/tickstep/aliyunpan/releases/download/v0.3.3/aliyunpan-v0.3.3-linux-amd64.zip
unzip aliyunpan-v0.3.3-linux-amd64.zip
echo "alias alipan='~/software/aliyunpan-v0.3.3-linux-amd64/aliyunpan'" >> ~/.zshrc && source ~/.zshrc
