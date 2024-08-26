
# cuda和torch的dockers镜像：https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/rel-23-07.html#rel-23-07
# nvcr.io/nvidia/pytorch:23.07-py3
# 可以看readme以方便国内同步和下载
# 下面是已经同步好了的
FROM registry.cn-hangzhou.aliyuncs.com/yywind/pytorch:23.07-py3

# FROM m.daocloud.io/docker.io/continuumio/miniconda3:latest

ARG DEBIAN_FRONTEND=noninteractive

COPY sources.list /etc/apt/sources.list
# 更新软件包列表，并安装基本软件
RUN apt-get -y update && apt-get install -y vim htop tmux git ssh wget curl net-tools iproute2

# 安装ohmyzsh，并加入插件 zsh-syntax-highlighting 和 zsh-autosuggestions
RUN apt-get -y update && apt-get install -y zsh && \
    apt install -y python3-pip && pip3 install --upgrade pip

RUN git clone  --depth=1 https://gitee.com/lqhhhhhh/ohmyzsh  ~/.oh-my-zsh && \
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc && \
    sed -i 's/robbyrussell/agnoster/g' ~/.zshrc && \
    sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/g' ~/.zshrc

RUN git clone --depth=1 https://gitee.com/di2344/powerlevel10k ~/.oh-my-zsh/custom/themes/powerlevel10k && \
    git clone https://gitee.com/di2344/zsh-syntax-highlighting  ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
    git clone https://gitee.com/czyczk/zsh-autosuggestions  ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
    git clone https://gitee.com/YuanWind/p10k ~/.oh-my-zsh/p10k_config

RUN cp ~/.oh-my-zsh/p10k_config/.p10k.zsh ~/.p10k.zsh

RUN sed -i 's/ZSH_THEME="agnoster"/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ~/.zshrc

RUN sed -i '# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.\n# Initialization code that may require console input (password prompts, [y/n]\n# confirmations, etc.) must go above this block; everything else may go below.\nif [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then\n  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"\nfi' ~/.zshrc

RUN echo '# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh. ' >> ~/.zshrc
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



RUN pip install --no-cache-dir jupyterlab ipywidgets jupyterlab-topbar jupyterlab-system-monitor lckr-jupyterlab-variableinspector -i https://pypi.tuna.tsinghua.edu.cn/simple

RUN pip install huggingface_hub -i https://pypi.tuna.tsinghua.edu.cn/simple

RUN git clone https://gitee.com/YuanWind/paperspace-prepare ~/paperspace-prepare
RUN bash ~/paperspace-prepare/init_yunpan.sh
RUN echo "alias hfd='bash ~/paperspace-prepare/hfd.sh'" >> ~/.zshrc

RUN echo "export PATH='/opt/conda/bin:$PATH'" >> ~/.zshrc

# 设置默认工作目录
# WORKDIR /root

# 设置默认shell
RUN chsh -s $(which zsh)

EXPOSE 8888
# ----------------- 使用VSCODE启动 -----------------------------
# 安装vscode，依赖 /vscode-install.sh
COPY install.sh /vscode-install.sh
RUN bash /vscode-install.sh

# 将code-server的缓存路径改为paperspace的永久性存储路径
RUN mkdir -p ~/.local/share
RUN ln -s /storage/code-server ~/.local/share/code-server

COPY vscode.sh /start_vscode.sh

ENTRYPOINT ["/start_vscode.sh"]
# ----------------- 使用VSCODE启动 -----------------------------

# ----------------- 使用jupyter启动 -----------------------------
# CMD ["bash", "-c", "source ~/.bashrc && jupyter lab --ip 0.0.0.0 --no-browser --allow-root"]
# ----------------- 使用VSCODE启动 -----------------------------
