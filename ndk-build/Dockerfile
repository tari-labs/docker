FROM quay.io/tarilabs/rust_tari-build-with-deps:nightly-2020-01-08

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

# Add Android cross compilers
ARG TARGETS="x86_64-linux-android aarch64-linux-android armv7-linux-androideabi i686-linux-android arm-linux-androideabi"

ENV NDK_HOME=${NDK_PATH} NDK_TOOLCHAIN_VERSION=clang

RUN rustup target add ${TARGETS}
RUN cargo install cargo-ndk

# Build Android libs
ADD scripts /scripts
ENV PLATFORMS  "x86_64-linux-android aarch64-linux-android armv7-linux-androideabi i686-linux-android arm-linux-androideabi"
ENV LEVEL "24"
ENV SRC_DIR "/src"
ENV CARGO_FLAGS "--release"
# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT "/scripts/entrypoint.sh" ${PLATFORMS} ${LEVEL} ${SRC_DIR}