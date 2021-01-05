#!/bin/bash

# Build a native library for the given platform.
# Assume source code resides at GITHUB_WORKSPACE
PLATFORMABIS=$1
LEVEL=$2
SRCDIR=$3

set -e
IFS=';' read -ra PLATFORMARRAY <<< "$PLATFORMABIS"

for PLATFORMABI in "${PLATFORMARRAY[@]}"
do
  echo "Building ${SRCDIR} for ${PLATFORMABI} on level ${LEVEL}"
  PLATFORM=$(cut -d'-' -f1 <<<"${PLATFORMABI}")

  # Directory mappings for build abi vs expected directory structure for jniLibs.
  PLATFORM_OUTDIR=""
  if [ "${PLATFORM}" == "i686" ]; then
    PLATFORM_OUTDIR="x86"
    elif [ "${PLATFORM}" == "x86_64" ]; then
    PLATFORM_OUTDIR="x86_64"
    elif [ "${PLATFORM}" == "armv7" ]; then
    PLATFORM_OUTDIR="armeabi-v7a"
    elif [ "${PLATFORM}" == "aarch64" ]; then
    PLATFORM_OUTDIR="arm64-v8a"
    else
    PLATFORM_OUTDIR=${PLATFORM}
  fi

  # Configure C build environment to use the tools in the NDK
  # When configuring dependencies these variables will be used by Make

  PLATFORMABI_TOOLCHAIN=${PLATFORMABI}
  PLATFORMABI_COMPILER=${PLATFORMABI}

  # Handle the special case
  if [ "${PLATFORMABI}" == "armv7-linux-androideabi" ]; then
    PLATFORMABI_TOOLCHAIN="arm-linux-androideabi"
    PLATFORMABI_COMPILER="armv7a-linux-androideabi"
  fi

  cd /ssl
  ANDROID_NDK_HOME=${NDK_PATH}
  export AR=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin/${PLATFORMABI_TOOLCHAIN}$'-'ar
  export AS=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin/${PLATFORMABI_TOOLCHAIN}$'-'as
  export LD=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin/${PLATFORMABI_TOOLCHAIN}$'-'ld
  export RANLIB=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin/${PLATFORMABI_TOOLCHAIN}$'-'ranlib
  export STRIP=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin/${PLATFORMABI_TOOLCHAIN}$'-'strip
  CC=${NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin/${PLATFORMABI_COMPILER}
  export CC=${CC}${LEVEL}$'-'clang
  export CXX=${CC}++

  # Configure build or show log on error
  echo "Make Config: ${PLATFORMABI}"
  PATH=${ANDROID_NDK_HOME}/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64/bin:${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin:${ANDROID_NDK_HOME}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin:$PATH
  export ANDROID_NDK_HOME
  OUTPUT_DIR=/platforms/ssl/${PLATFORMABI}
  case ${PLATFORM} in
  armv7)
  ./Configure android-arm --target=${PLATFORMABI_COMPILER} -Wl,--fix-cortex-a8 -fPIC -no-zlib -no-hw -no-engine -no-shared -D__ANDROID_API__=${LEVEL}
  make build_libs
  make install DESTDIR=${OUTPUT_DIR}
  echo "File Format:"
  objdump -f /platforms/ssl/${PLATFORMABI}/usr/local/lib/libcrypto.a
  objdump -f /platforms/ssl/${PLATFORMABI}/usr/local/lib/libssl.a
    ;;
  x86_64)
  ./Configure android-x86_64 --target=${PLATFORMABI_COMPILER} -fPIC -no-zlib -no-hw -no-engine -no-shared -D__ANDROID_API__=${LEVEL}
  make build_libs
  make install DESTDIR=${OUTPUT_DIR}
  echo "File Format:"
  objdump -f /platforms/ssl/${PLATFORMABI}/usr/local/lib/libcrypto.a
  objdump -f /platforms/ssl/${PLATFORMABI}/usr/local/lib/libssl.a
    ;;
  aarch64)
  ./Configure android-arm64 --target=${PLATFORMABI_COMPILER} -fPIC -no-zlib -no-hw -no-engine -no-shared -D__ANDROID_API__=${LEVEL}
  make build_libs
  make install DESTDIR=${OUTPUT_DIR}
  echo "File Format:"
  objdump -f /platforms/ssl/${PLATFORMABI}/usr/local/lib/libcrypto.a
  objdump -f /platforms/ssl/${PLATFORMABI}/usr/local/lib/libssl.a
    ;;
  x86)
  ./Configure android-x86 --target=${PLATFORMABI_COMPILER} -fPIC -no-zlib -no-hw -no-engine -no-shared -D__ANDROID_API__=${LEVEL}
  make build_libs
  make install DESTDIR=${OUTPUT_DIR}
  echo "File Format:"
  objdump -f /platforms/ssl/${PLATFORMABI}/usr/local/lib/libcrypto.a
  objdump -f /platforms/ssl/${PLATFORMABI}/usr/local/lib/libssl.a
  ;;
  esac
  make clean
done

echo "Done"
ls -l /platforms
ls -lR /platforms
