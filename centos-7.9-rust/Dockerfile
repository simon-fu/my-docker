FROM centos:centos7.9.2009

# LABEL maintianer="simon"

RUN yum update -y
RUN yum install centos-release-scl -y 
RUN yum install llvm-toolset-7 -y
RUN yum install https://vault.centos.org/centos/8/PowerTools/x86_64/os/Packages/yasm-1.3.0-7.el8.x86_64.rpm -y
RUN yum groupinstall 'Development Tools' -y
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# RUN source scl_source enable llvm-toolset-7
RUN echo "source scl_source enable llvm-toolset-7" >> /etc/bash.bashrc


