# FROM nvcr.io/nvidia/pytorch:24.07-py3-igpu

FROM m.daocloud.io/docker.io/continuumio/miniconda3:latest

ARG DEBIAN_FRONTEND=noninteractive

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

RUN echo '# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh. \n[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> ~/.zshrc

# 设置locale为中文UTF-8
RUN apt-get -y update && \
    apt-get install -y locales unzip && \
    echo "zh_CN.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen zh_CN.UTF-8 && \
    update-locale LANG=zh_CN.UTF-8 LC_ALL=zh_CN.UTF-8

# 设置时区为上海
RUN apt-get -y update && \
    apt-get install -y tzdata && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata



RUN pip install --no-cache-dir jupyterlab jupyterlab-topbar jupyterlab-system-monitor lckr-jupyterlab-variableinspector 


# 设置默认工作目录
WORKDIR /root

# 设置默认shell
SHELL ["/usr/bin/zsh"]

EXPOSE 8888
    
CMD ["bash", "-c", "source /etc/bash.bashrc && jupyter lab --ip 0.0.0.0 --no-browser --allow-root"]
