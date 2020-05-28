FROM quay.io/tarilabs/rust_tari-build-with-deps:nightly-2020-01-08
RUN apt-get update
RUN apt-get -y install libc++abi-dev
RUN apt-get -y install libc++-dev
ARG NDK_VERSION=r21b
ARG ANDROID_NDK_HOME=/opt/android-ndk

# Download and install NDK
RUN mkdir -p /opt/android-ndk-tmp && \
    cd /opt/android-ndk-tmp && \
    wget https://dl.google.com/android/repository/android-ndk-${NDK_VERSION}-linux-x86_64.zip && \
    cd /opt/android-ndk-tmp && \
    unzip android-ndk-${NDK_VERSION}-linux-x86_64.zip && \
    mv /opt/android-ndk-tmp/android-ndk-${NDK_VERSION} /opt/android-ndk
# add to PATH
ENV PATH ${PATH}:${ANDROID_NDK_HOME}
ENV NDK_PATH ${ANDROID_NDK_HOME}

#Fix for missing header, c code should reference limits.h instead of syslimits.h, happens with code that has been around for a long time.
RUN mkdir -p ${NDK_PATH}/sources/cxx-stl/llvm-libc++/include/sys
RUN cp "${NDK_PATH}/sources/cxx-stl/llvm-libc++/include/limits.h" "${NDK_PATH}/sources/cxx-stl/llvm-libc++/include/sys/syslimits.h"

# Add Android ABIs
ARG TARGETS="x86_64-linux-android aarch64-linux-android armv7-linux-androideabi i686-linux-android arm-linux-androideabi"
ARG LEVEL=24
ENV NDK_HOME=${NDK_PATH} NDK_TOOLCHAIN_VERSION=clang
RUN rustup target add ${TARGETS}

# Build Android libs
ADD scripts /scripts
# We'll build a version of the library for every platform given in `PLATFORMS`. Separate multiple platforms by a semicolon
ENV PLATFORMS  "x86_64-linux-android;aarch64-linux-android;i686-linux-android;armv7-linux-androideabi"
# Cargo will build the source code found in SRC_DIR
ENV SRC_DIR "/src"
# You can pass any flags you wish to cargo by overriding the CARGO_FLAGS envar
ENV CARGO_FLAGS "--lib --release"
ENV LEVEL=${LEVEL}
# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT "/scripts/entrypoint.sh" "${PLATFORMS}" "${LEVEL}" "${SRC_DIR}"
