FROM ubuntu:16.04
MAINTAINER yuua <noguchi-yuya@dmm.com>

RUN apt-get update && apt-get install -y wget checkinstall ccache
COPY ccache/* /usr/local/bin/
RUN echo "export CC=\"/usr/local/bin/ccache-gcc\"" >> ~/.bashrc && echo "export CXX=\"/usr/local/bin/ccache-gxx\"" >> ~/.bashrc && . ~/.bashrc

RUN wget https://github.com/ku-nlp/jumanpp/releases/download/v2.0.0-rc2/jumanpp-2.0.0-rc2.tar.xz && \
  tar xvf jumanpp-2.0.0-rc2.tar.xz && \
  wget https://cmake.org/files/v3.12/cmake-3.12.4.tar.gz && \
  tar xvf cmake-3.12.4.tar.gz && \
  cd cmake-3.12.4 && \
  ./configure CFLAGS="-O3" CXXFLAGS="-O3" && make -j $(grep -c ^processor /proc/cpuinfo) && checkinstall && \
  export PATH="/usr/local/bin:$PATH" && \
  cd /app/jumanpp-2.0.0-rc2 && mkdir build && \
  cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local && \
  make  -j $(grep -c ^processor /proc/cpuinfo) && checkinstall && \
  wget http://nlp.ist.i.kyoto-u.ac.jp/DLcounter/lime.cgi?down=http://nlp.ist.i.kyoto-u.ac.jp/nl-resource/knp/knp-4.19.tar.bz2&name=knp-4.19.tar.bz2 && \
  tar xvf knp-4.19.tar.bz2 && \
  cd /app/knp-4.19 && ./configure CFLAGS="-O3" CXXFLAGS="-O3" &&  make -j $(grep -c ^processor /proc/cpuinfo) && checkinstall

