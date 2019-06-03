# 2018-01-12: This Dockerfile is based on http://files.fast.ai/setup/paperspace

#10.1-cudnn7-runtime-ubuntu16.04 
FROM nvidia/cuda:10.0-cudnn7-runtime-ubuntu16.04

#################
## Vim setting ##
#################

# To allow unicode characters in the terminal
ENV LANG C.UTF-8

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

RUN git clone https://github.com/seungwooYoo/Dotvims.git .vim
WORKDIR .vim

RUN git submodule update --init --recursive
RUN git submodule foreach git checkout master
RUN git submodule foreach git pull
RUN python3 /.vim/bundle/YouCompleteMe/install.py

RUN apt-get install -y python3-pip 

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
RUN /bin/bash -c "\
    conda install mkl-service"
Run conda install -c conda-forge opencv
Run conda install -c numpy scipy matplotlib scikit-image scikit-learn pandas seaborn
Run conda install pytorch torchvision cudatoolkit=10.0 -c pytorch
RUN echo "export MKL_DYNAMIC=FALSE" >> ~/.bashrc
