# 2018-01-12: This Dockerfile is based on http://files.fast.ai/setup/paperspace

#10.1-cudnn7-runtime-ubuntu16.04 
FROM nvidia/cuda:10.0-cudnn7-runtime-ubuntu16.04

#################
## Vim setting ##
#################

# To allow unicode characters in the terminal
ENV LANG C.UTF-8

RUN useradd -ms /bin/bash -G sudo yoos

###########
## Tools ##
###########
RUN apt-get update --fix-missing && apt-get install -y \
    build-essential \
    cmake \ 
    wget \
    vim \
    git \
    zip \
    unzip \
	ctags \ 
	curl \
	python3 \
    python3-dev

RUN git clone https://github.com/seungwooYoo/Dotvims.git /home/yoos/.vim
WORKDIR /home/yoos/.vim

RUN git submodule update --init --recursive
RUN git submodule foreach git checkout master
RUN git submodule foreach git pull
RUN python3 /home/yoos/.vim/bundle/YouCompleteMe/install.py

RUN apt-get install -y python3-pip 
RUN apt-get install -y sudo

# Python 3.5
RUN pip3 install https://download.pytorch.org/whl/cu100/torch-1.1.0-cp35-cp35m-linux_x86_64.whl
RUN pip3 install https://download.pytorch.org/whl/cu100/torchvision-0.3.0-cp35-cp35m-linux_x86_64.whl

RUN apt-get update --fix-missing && apt-get install -y \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1

##############
## Anaconda ##
##############

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.anaconda.com/archive/Anaconda3-2019.03-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh

ENV PATH /opt/conda/bin:$PATH

#RUN git clone https://github.com/fastai/fastai.git /code/fastai
RUN /bin/bash

# Solves: `libjpeg.so.8: cannot open shared object file: No such file or directory`
#          after `from PIL import Image`
RUN apt-get install -y libjpeg-turbo8

# https://software.intel.com/en-us/mkl
Run /bin/bash -c conda install mkl-service
Run conda install -c conda-forge opencv
Run conda install -c numpy scipy matplotlib scikit-image scikit-learn pandas seaborn
Run conda install pytorch torchvision cudatoolkit=10.0 -c pytorch

RUN echo "export MKL_DYNAMIC=FALSE" >> ~/.bashrc

# Bash
RUN mkdir /home/yoos/.bash
WORKDIR /home/yoos/.bash
RUN git clone git://github.com/jimeh/git-aware-prompt.git
RUN cp /home/yoos/.vim/vimrc /home/yoos/.vimrc
RUN echo "export TERM=xterm-256color" >> /home/yoos/.bashrc
RUN echo "set -o vi" >> /home/yoos/.bashrc
RUN echo "export EDITOR=vim" >> /home/yoos/.bashrc
RUN echo "export GITAWAREPROMPT=/home/yoos/.bash/git-aware-prompt" >> /home/yoos/.bashrc
RUN echo "source \"/home/yoos/.bash/git-aware-prompt/main.sh\"" >> /home/yoos/.bashrc
RUN echo "export PS1=\"\${debian_chroot:+(\$debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ \"" >> /home/yoos/.bashrc

#RUN source /home/yoos/.bashrc
#CMD source activate ...

USER yoos
