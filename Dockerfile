
# cuda和torch的dockers镜像：https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/rel-23-07.html#rel-23-07
# nvcr.io/nvidia/pytorch:23.07-py3
# 可以看readme以方便国内同步和下载
# 下面是已经同步好了的
# FROM registry.cn-hangzhou.aliyuncs.com/yywind/pytorch:23.07-py3
FROM nvcr.io/nvidia/pytorch:23.07-py3
# FROM m.daocloud.io/docker.io/continuumio/miniconda3:latest

ARG DEBIAN_FRONTEND=noninteractive

# 替换清华源
COPY sources.list /etc/apt/sources.list
# 更新软件包列表，并安装基本软件
RUN apt-get -y update && apt-get install -y vim htop tmux git ssh wget curl net-tools iproute2

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


RUN apt install nodejs npm
RUN pip install --no-cache-dir jupyterlab jupyterlab-language-pack-zh-CN  jupyter_contrib_nbextensions ipywidgets jupyterlab-topbar jupyterlab-system-monitor lckr-jupyterlab-variableinspector -i https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip install huggingface_hub gpustat -i https://pypi.tuna.tsinghua.edu.cn/simple

RUN git clone https://github.com/YuanWind/paperspace-prepare ~/paperspace-prepare
RUN bash ~/paperspace-prepare/init_yunpan.sh
RUN echo "alias hfd='bash ~/paperspace-prepare/hfd.sh'" >> ~/.zshrc
RUN echo "export PATH='/opt/conda/bin:$PATH'" >> ~/.zshrc

# 设置默认工作目录
# WORKDIR /root

# 设置默认shell
RUN chsh -s $(which zsh)

# 安装 nodejs，jupyter lab的插件要用
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
RUN echo "export NVM_DIR='/usr/local/nvm'" >> ~/.zshrc
# download and install Node.js (you may need to restart the terminal)
RUN source ~/.bashrc
# RUN ls /usr/local/nvm apt
RUN bash /usr/local/nvm/nvm.sh install 22
# verifies the right Node.js version is in the environment
# RUN node -v # should print `v22.7.0`
# # verifies the right npm version is in the environment
# RUN npm -v # should print `10.8.2`

#安装jupyter必要插件
RUN pip install yapf
RUN jupyter contrib nbextension install --system
RUN jupyter nbextension enable code_prettify/code_prettify --system
RUN jupyter nbextension enable collapsible_headings/main --system
RUN jupyter nbextension enable execute_time/ExecuteTime --system
RUN jupyter nbextension enable hinterland/hinterland --system
RUN jupyter nbextension enable toggle_all_line_numbers/main --system
RUN jupyter nbextension enable autoscroll/main --system
RUN pip install jupyter_latex_envs --upgrade
RUN jupyter nbextension install --py latex_envs --system
RUN jupyter nbextension install https://rawgit.com/jfbercher/jupyter_nbTranslate/master/nbTranslate.zip --system
RUN jupyter nbextension enable nbTranslate/main
RUN jupyter nbextension install https://rawgit.com/jfbercher/small_nbextensions/master/highlighter.zip  --system


EXPOSE 8888
# ----------------- 使用VSCODE启动 -----------------------------
# 安装vscode，依赖 /vscode-install.sh
COPY install.sh /vscode-install.sh
RUN bash /vscode-install.sh

# 将code-server的缓存路径改为paperspace的永久性存储路径， jupyter的缓存路径也放里边。
RUN mkdir -p ~/.local/share
RUN ln -s /storage/.local/share/code-server ~/.local/share/code-server
# RUN ln -s /storage/.local/share/jupyter ~/.local/share/jupyter

COPY vscode.sh /start_vscode.sh

ENTRYPOINT ["/start_vscode.sh"]
# ----------------- 使用VSCODE启动 -----------------------------

# ----------------- 使用jupyter启动 -----------------------------
# CMD ["bash", "-c", "source ~/.bashrc && jupyter lab --ip 0.0.0.0 --no-browser --allow-root"]
# ----------------- 使用VSCODE启动 -----------------------------
