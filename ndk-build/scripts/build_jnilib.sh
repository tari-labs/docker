#!/bin/bash

# Build a native library for the given platform.
# Assume source code resides at GITHUB_WORKSPACE
PLATFORMABI=$1
LEVEL=$2
OUTDIR=/opt/lib/${PLATFORMABI}
SRCDIR=$3

echo "Building ${SRCDIR} for ${PLATFORMABI} on level ${LEVEL}"

# set toolchain path
TOOLCHAIN=${NDK_PATH}/toolchains/llvm/prebuilt/linux-x86_64
PLATFORMABI_TOOLCHAIN=${PLATFORMABI}
PLATFORMABI_COMPILER=${PLATFORMABI}
if [ "${PLATFORMABI}" = "armv7-linux-androideabi" ]; then \
    PLATFORMABI_TOOLCHAIN="arm-linux-androideabi"
    PLATFORMABI_COMPILER="armv7a-linux-androideabi"
fi
# set the archiver
AR=${TOOLCHAIN}/bin/${PLATFORMABI_TOOLCHAIN}'-'ar
# set the assembler
AS=${TOOLCHAIN}/bin/${PLATFORMABI_TOOLCHAIN}'-'as
# set the c and c++ compiler
CC=${TOOLCHAIN}/bin/${PLATFORMABI_COMPILER}${LEVEL}'-'clang
CXX=${CC}++
CXXFLAGS="-stdlib=libstdc++ -isystem ${NDK_PATH}/sources/cxx-stl/llvm-libc++/include"
echo "CXXFLAGS: ${CXXFLAGS}"
echo "CFLAGS: ${CFLAGS}"
echo "CPPFLAGS: ${CPPFLAGS}"
# set the lin
LD=${TOOLCHAIN}/bin/${PLATFORMABI_TOOLCHAIN}'-'ld
# set linker flags
LDFLAGS="-L${TOOLCHAIN}/sysroot/usr/lib/${PLATFORMABI_TOOLCHAIN}/${LEVEL} -L${OUTDIR}/lib ${LDEXTRA}"
echo "LDFLAGS: ${LDFLAGS}"
# set the archive index generator tool
RANLIB=${TOOLCHAIN}/bin/${PLATFORMABI_TOOLCHAIN}'-'ranlib
# set the symbol stripping tool
STRIP=${TOOLCHAIN}/bin/${PLATFORMABI_TOOLCHAIN}'-'strip

cd ${SRCDIR}
cargo ndk --target ${PLATFORMABI} --android-platform ${LEVEL} -- build ${CARGO_FLAGS}