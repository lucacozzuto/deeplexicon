FROM ubuntu:bionic

MAINTAINER Luca Cozzuto <lucacozzuto@gmail.com>

ARG PYTHON_VERSION=3.7.6
ARG DEBIAN_FRONTEND=noninteractive


RUN apt-get update
RUN apt-get install -y build-essential zlib1g-dev curl liblzma-dev libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev
RUN curl https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz -o Python-${PYTHON_VERSION}.tgz
RUN tar -zxf Python-${PYTHON_VERSION}.tgz; rm Python-${PYTHON_VERSION}.tgz ; cd Python-${PYTHON_VERSION}; ./configure; make; make install
RUN ln -s /usr/local/bin/python3 /usr/local/bin/python; ln -s /usr/local/bin/pip3 /usr/local/bin/pip

#Installing modules for Deeplexicon
RUN pip install --upgrade pip setuptools
RUN pip install pyts numba==0.45.0 keras==2.2.4 scikit-learn pandas TensorFlow==1.13.1

#Installing Deeplexicon
RUN apt-get install -y git liblzma-dev
RUN git clone --depth 1 https://github.com/Psy-Fer/deeplexicon.git
RUN chmod +x deeplexicon/deeplexicon.py
ENV PATH "$PWD/deeplexicon/:${PATH}" 

# Cleanup
RUN apt-get clean && apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* 
RUN locale-gen en_US.UTF-8