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
  # Additionally CC, AR and the library paths of the dependencies get passed to rust

  PLATFORMABI_TOOLCHAIN=${PLATFORMABI}
  PLATFORMABI_COMPILER=${PLATFORMABI}

  # Handle the special case
  if [ "${PLATFORMABI}" == "armv7-linux-androideabi" ]; then
    PLATFORMABI_TOOLCHAIN="arm-linux-androideabi"
    PLATFORMABI_COMPILER="armv7a-linux-androideabi"
  fi

  # set toolchain path
  export TOOLCHAIN=${NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/${PLATFORMABI_TOOLCHAIN}
  echo "Toolchain path: ${TOOLCHAIN}"

  # set the archiver
  export AR=${NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin/${PLATFORMABI_TOOLCHAIN}$'-'ar
  echo "Archiver: ${AR}"

  # set the assembler
  export AS=${NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin/${PLATFORMABI_TOOLCHAIN}$'-'as
  echo "Assembler: ${AS}"

  # set the c and c++ compiler
  CC=${NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin/${PLATFORMABI_COMPILER}
  export CC=${CC}${LEVEL}$'-'clang
  export CXX=${CC}++
  echo "C Compiler: ${CC}"
  echo "CXX Compiler: ${CXX}"

  export CXXFLAGS="-stdlib=libstdc++ -isystem ${NDK_HOME}/sources/cxx-stl/llvm-libc++/include"
  echo "CXX Flags: ${CXXFLAGS}"

  # set the linker
  export LD=${NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin/${PLATFORMABI_TOOLCHAIN}$'-'ld
  echo "Linker ${LD}"

  # set linker flags
  export LDFLAGS="-L${NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/${PLATFORMABI_TOOLCHAIN}/${LEVEL} -L${OUTPUT_DIR}/lib -lc++"
  echo "Linker Flags: ${LDFLAGS}"

  # set the archive index generator tool
  export RANLIB=${NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin/${PLATFORMABI_TOOLCHAIN}$'-'ranlib
  echo "Archive Indexer: ${RANLIB}"

  # set the symbol stripping tool
  export STRIP=${NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin/${PLATFORMABI_TOOLCHAIN}$'-'strip
  echo "Symbol Stripper: ${STRIP}"

  # set c flags
  #note: Add -v to below to see compiler output, include paths, etc
  export CFLAGS="-DMDB_USE_ROBUST=0"
  echo "C Flags: ${CFLAGS}"

  # set cpp flags
  export CPPFLAGS="-fPIC -I/sqlite/include"
  echo "CPP Flags: ${CPPFLAGS}"

  cd /sqlite
  # Configure build or show log on error
  echo "Make Config: ${PLATFORMABI}"
  ./configure --host=${PLATFORMABI} --prefix="/platforms/${PLATFORMABI}" || cat config.log
  make install
  make clean
  echo "File Format:"
  objdump -f /platforms/${PLATFORMABI}/lib/libsqlite3.a
done

echo "Done"
ls -l /platforms
ls -lR /platforms