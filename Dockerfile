# nvcr.io/nvidia/tritonserver:24.05-vllm-python-py3
FROM nvcr.io/nvidia/tritonserver:24.05-trtllm-python-py3

ARG DEBIAN_FRONTEND=noninteractive

# 替换清华源
COPY sources.list /etc/apt/sources.list
# 更新软件包列表，并安装基本软件
RUN apt-get -y update && apt-get install -y vim htop tmux git ssh wget curl net-tools iproute2 sudo

# 安装ohmyzsh，并加入插件 zsh-syntax-highlighting 和 zsh-autosuggestions
RUN apt-get -y update && apt-get install -y zsh

RUN git clone  --depth=1 https://github.com/ohmyzsh/ohmyzsh.git  ~/.oh-my-zsh && \
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc && \
    sed -i 's/robbyrussell/agnoster/g' ~/.zshrc && \
    sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/g' ~/.zshrc

RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git  ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
    git clone https://github.com/zsh-users/zsh-autosuggestions.git  ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
    git clone https://gitee.com/YuanWind/p10k ~/.oh-my-zsh/p10k_config

RUN rm /etc/apt/apt.conf.d/20packagekit

RUN cp ~/.oh-my-zsh/p10k_config/.p10k.zsh ~/.p10k.zsh

RUN sed -i 's/ZSH_THEME="agnoster"/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ~/.zshrc

RUN echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> ~/.zshrc

# 设置locale为中文UTF-8
RUN apt-get -y update && \
    apt-get install -y locales unzip aria2 git-lfs curl && \
    echo "zh_CN.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen zh_CN.UTF-8 && \
    update-locale LANG=zh_CN.UTF-8 LC_ALL=zh_CN.UTF-8

# 设置时区为上海
RUN apt-get -y update && \
    apt-get install -y tzdata && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata


RUN apt install -y nodejs npm
RUN pip install --no-cache-dir jupyterlab jupyterlab-language-pack-zh-CN  jupyter_contrib_nbextensions ipywidgets jupyterlab-topbar jupyterlab-system-monitor lckr-jupyterlab-variableinspector -i https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip install huggingface_hub gpustat -i https://pypi.tuna.tsinghua.edu.cn/simple

# 设置默认shell
RUN chsh -s $(which zsh)


EXPOSE 8888
# ----------------- 使用VSCODE启动 -----------------------------
# 安装vscode，依赖 /vscode-install.sh
COPY install.sh /vscode-install.sh
RUN bash /vscode-install.sh

# 将code-server的缓存路径改为paperspace的永久性存储路径， jupyter的缓存路径也放里边。
RUN mkdir -p ~/.local/share
RUN ln -s /storage/.local/share/code-server ~/.local/share/code-server

COPY vscode.sh /start_vscode.sh

