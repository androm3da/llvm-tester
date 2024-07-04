
FROM ubuntu:20.04

RUN useradd llvmbuild

#VOLUME ['/tmp/']
RUN apt-get -qq update && DEBIAN_FRONTEND=noninteractive apt-get -qq install -y --force-yes \
        build-essential subversion chrpath wget file python  \
        cmake ninja-build tar libxml2-dev libedit-dev swig4.0 python3-dev libncurses5-dev \
	lld clang curl python3-venv liblua5.3-dev

USER llvmbuild
RUN cd /tmp && \
	wget --quiet https://github.com/Kitware/CMake/releases/download/v3.28.2/cmake-3.28.2-linux-x86_64.tar.gz && \
	tar xf cmake-3.28.2-linux-x86_64.tar.gz && \
	ln -sf cmake-3.28.2-linux-x86_64 cmake

#RUN apt-get -qq update && apt-get -qq install -y --force-yes \
#        git

#RUN cd /tmp && \
#	git clone https://github.com/rui314/mold.git && \
#	cd mold && \
#        CC=clang CXX=clang++ /tmp/cmake/bin/cmake -B build -S $PWD && \
#	/tmp/cmake/bin/cmake --build ./build -- install

RUN cd /tmp && \
    wget  --quiet https://raw.githubusercontent.com/llvm/llvm-project/main/llvm/utils/release/test-release.sh && \
    chmod +x test-release.sh && \
	PATH=/tmp/cmake/bin:$PATH && \
        CC=clang CXX=clang++ ./test-release.sh -release 18.1.7 -final \
        -no-flang \
        -no-lldb \
	-triple x86_64-linux-gnu-ubuntu-18.04 \
	-configure-flags "-DLLVM_ENABLE_LLD=ON -DLLVM_PARALLEL_COMPILE_JOBS=12 -DLLVM_PARALLEL_LINK_JOBS=2 -DLLDB_ENABLE_PYTHON=ON" \
        -use-ninja \
         || /bin/true

#     CXX=/tmp/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang++ \
#     CC=/tmp/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang \
#   wget --quiet https://releases.llvm.org/8.0.0/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04.tar.xz && \
#   tar xf clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-14.04.tar.xz && \
#   /usr/bin/env \
