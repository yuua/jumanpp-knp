FROM ubuntu:16.04
MAINTAINER yuua <noguchi-yuya@dmm.com>

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:jonathonf/python-3.6 && \
    apt-get update && \
    apt-get install -y python3.6 python3.6-dev wget checkinstall ccache git

COPY ccache/* /usr/local/bin/

RUN echo "export CC=\"/usr/local/bin/ccache-gcc\"" >> ~/.bashrc && \
    echo "export CXX=\"/usr/local/bin/ccache-gxx\"" >> ~/.bashrc && \
    . ~/.bashrc && \
    chmod 755 /usr/local/bin/ccache-gcc && \
    chmod 755 /usr/local/bin/ccache-gxx

WORKDIR /work

RUN wget --no-check-certificate -q https://bootstrap.pypa.io/get-pip.py -O get-pip.py && python3.6 get-pip.py && \
    wget --no-check-certificate -q https://github.com/ku-nlp/jumanpp/releases/download/v2.0.0-rc2/jumanpp-2.0.0-rc2.tar.xz -O jumanpp-2.0.0-rc2.tar.xz && \
    tar Jxfv jumanpp-2.0.0-rc2.tar.xz && \
    git clone -b v3.12.4 https://gitlab.kitware.com/cmake/cmake.git && \
    wget --no-check-certificate -q http://nlp.ist.i.kyoto-u.ac.jp/nl-resource/knp/knp-4.19.tar.bz2 -O knp-4.19.tar.bz2 && \
    tar xvf knp-4.19.tar.bz2

WORKDIR /work/cmake-3.12.4 && \
    ./configure CFLAGS="-O3" CXXFLAGS="-O3" && \
    make -j $(grep -c ^processor /proc/cpuinfo) && \
    checkinstall -y && \
    export PATH="/usr/local/bin:$PATH"

WORKDIR /work/jumanpp-2.0.0-rc2 && \
    mkdir build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local && \
    make  -j $(grep -c ^processor /proc/cpuinfo) && checkinstall -y

WORKDIR /work/knp-4.19 && \
    ./configure CFLAGS="-O3" CXXFLAGS="-O3" && \
    make -j $(grep -c ^processor /proc/cpuinfo) && \
    checkinstall -y

