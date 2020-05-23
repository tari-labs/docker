FROM ubuntu:20.04 as base

ARG PLATFORMS="x86_64-linux-android aarch64-linux-android armv7-linux-androideabi"
ARG SQLITE_VERSION=sqlite-snapshot-201911192122
ARG SQLITE_SOURCE=https://www.sqlite.org/snapshot/${SQLITE_VERSION}.tar.gz

# valgrind libncurses5-dev libncursesw5-dev libunwind-dev libsystemd-dev liblz4-dev libpcre3-dev libsodium-dev libmicrohttpd-dev
#             libllvm9 llvm-9 llvm-9-dev llvm-9-runtime llvm-9-tools \
#            libfuzzer-9-dev \

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -yy --no-install-recommends \
        ca-certificates \
        gcc \
        libc6-dev \
        wget \
        curl \
        git \
        build-essential libtool pkg-config autotools-dev autoconf automake cmake uuid-dev \
        libssl-dev \
        clang-9 clang-tools-9 libclang-common-9-dev libclang-9-dev libclang1-9 clang-format-9 clangd-9 \
        libc++-9-dev libc++abi-9-dev \
        tree
RUN apt-get purge -y procps && \
    apt-get upgrade -y
RUN apt-get remove -y --auto-remove wget && \
    rm -rf /var/lib/apt/lists/*;
# Downloads
RUN mkdir -p /src && \
    mkdir -p /platforms/sqlite
RUN curl -s ${SQLITE_SOURCE} | tar -xzvf - -C /src/

# Build SQLite libraries
RUN cd /src/${SQLITE_VERSION} &&\
    for PLATFORMABI in ${PLATFORMS}; do \
        OUTPUT_DIR=/platforms/sqlite/${ PLATFORMABI}; \
        make clean; \
        ./configure --host=${PLATFORMABI} --prefix=${OUTPUT_DIR}; \
        make install; \
     done

RUN tree /platforms >> /platforms/contents.txt && cat /platforms/contents.txt
FROM scratch
COPY --from=base /platforms /