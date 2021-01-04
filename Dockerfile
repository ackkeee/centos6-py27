FROM centos:6

LABEL maintainer="ackkeee"

ENV PYTHON27="https://www.python.org/ftp/python/2.7.9/Python-2.7.9.tgz"
ENV WORKSPACE="/opt/Pypkg"

COPY ./CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo

RUN yum update -y \
  && yum install -y \
  gcc \
  gcc-c++ \
  make \
  git \
  zlib-devel \
  readline-devel \
  sqlite-devel \
  openssl-devel \
  bzip2-devel \
  mysql-devel \
  libcurl-devel \
  python-devel \
  curl \
  wget \
  postfix \
  yum clean all

# python version up.
RUN mkdir ${WORKSPACE} \ 
  && cd ${WORKSPACE} \
  && curl -O ${PYTHON27} \
  && tar zxf Python-2.7.9.tgz \
  && cd ${WORKSPACE}/Python-2.7.9 \
  && ./configure --prefix=/usr/local \
  && make && make install && make clean \
  && rm ${WORKSPACE}/Python-2.7.9.tgz

# Install Supervisor
RUN wget https://bootstrap.pypa.io/get-pip.py \
  && python get-pip.py \
  && pip install supervisor

# Pre-start Postfix
COPY ./main.cf /etc/postfix/main.cf

