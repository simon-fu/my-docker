FROM centos:centos7.9.2009

# LABEL maintianer="simon"

RUN yum update -y
RUN yum install centos-release-scl -y 
RUN yum install llvm-toolset-7 -y
RUN yum install make -y

# RUN yum install openssl-devel -y

RUN source scl_source enable llvm-toolset-7 devtoolset-7 || true\
  && yum install openssl -y && yum install openssl-devel -y 

# RUN yum install http://mirror.centos.org/centos/7/sclo/x86_64/rh/Packages/l/llvm-toolset-7-clang-5.0.1-4.el7.x86_64.rpm -y
RUN yum install https://vault.centos.org/centos/8/PowerTools/x86_64/os/Packages/yasm-1.3.0-7.el8.x86_64.rpm -y
# RUN yum groupinstall 'Development Tools' -y

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y  

# ~/.bashrc   /etc/bash.bashrc
RUN echo "source scl_source enable llvm-toolset-7 devtoolset-7" >> ~/.bashrc

# ENV PATH="$PATH:$HOME/.cargo/bin"
ENV PATH="/root/.cargo/bin:${PATH}"
# ENV PATH="/opt/rh/llvm-toolset-7/root/usr/bin:/opt/rh/llvm-toolset-7/root/usr/sbin:${PATH}"
# SHELL ["/usr/bin/scl", "enable", "llvm-toolset-7"]

RUN yum install -y wget
RUN wget --quiet https://cmake.org/files/v3.12/cmake-3.12.2-Linux-x86_64.tar.gz \
    && tar -zxf cmake-3.12.2-Linux-x86_64.tar.gz \
    && mv cmake-3.12.2-Linux-x86_64 cmake-3.12.2 \
    && ln -sf /cmake-3.12.2/bin/* /usr/bin

# COPY dump_syms /usr/local/bin/
COPY build-dump-syms.sh /tmp/
RUN source "/root/.cargo/env" || true\
  && source scl_source enable llvm-toolset-7 devtoolset-7 || true\
  && /tmp/build-dump-syms.sh 
RUN /tmp/build-dump-syms.sh install_bin
RUN /tmp/build-dump-syms.sh clean_all

COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT [ "/usr/bin/entrypoint.sh" ]
