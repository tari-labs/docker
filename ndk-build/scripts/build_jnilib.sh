#!/bin/bash

# Build a native library for the given platform.
# Assume source code resides at GITHUB_WORKSPACE
PLATFORMABI=$1
LEVEL=$2
SRCDIR=$3

set -e
echo "Building ${SRCDIR} for ${PLATFORMABI} on level ${LEVEL}"

#PLATFORM=$(cut -d'-' -f1 <<<"${PLATFORMABI}")
#PLATFORM_OUTDIR=""
#if [ "${PLATFORM}" == "i686" ]; then
#  PLATFORM_OUTDIR="x86"
#  elif [ "${PLATFORM}" == "x86_64" ]; then
#    PLATFORM_OUTDIR="x86_64"
#  elif [ "${PLATFORM}" == "armv7" ]; then
#    PLATFORM_OUTDIR="armeabi-v7a"
#  elif [ "${PLATFORM}" == "aarch64" ]; then
#    PLATFORM_OUTDIR="arm64-v8a"
#  else
#    PLATFORM_OUTDIR=${PLATFORM}
#fi
#
## set toolchain path
#TOOLCHAIN=${NDK_PATH}/toolchains/llvm/prebuilt/linux-x86_64
#PLATFORMABI_TOOLCHAIN=${PLATFORMABI}
#PLATFORMABI_COMPILER=${PLATFORMABI}
#if [ "${PLATFORMABI}" = "armv7-linux-androideabi" ]; then \
#    PLATFORMABI_TOOLCHAIN="arm-linux-androideabi"
#    PLATFORMABI_COMPILER="armv7a-linux-androideabi"
#fi
## set the archiver
#export AR=${TOOLCHAIN}/bin/${PLATFORMABI_TOOLCHAIN}'-'ar
## set the assembler
#export AS=${TOOLCHAIN}/bin/${PLATFORMABI_TOOLCHAIN}'-'as
## set the c and c++ compiler
#export CC=${TOOLCHAIN}/bin/${PLATFORMABI_COMPILER}${LEVEL}'-'clang
#export CXX=${CC}++
#export CXXFLAGS="-stdlib=libstdc++ -isystem ${NDK_PATH}/sources/cxx-stl/llvm-libc++/include"
#echo "CXXFLAGS: ${CXXFLAGS}"
#
export CFLAGS=${CFLAGS/PF/$PLATFORMABI}
echo "CFLAGS: ${CFLAGS}"
#
export CPPFLAGS=${CPPFLAGS/PF/$PLATFORMABI}
echo "CPPFLAGS: ${CPPFLAGS}"

export RUSTFLAGS=${RUSTFLAGS/PF/$PLATFORMABI}
echo "RUSTFLAGS: ${RUSTFLAGS}"
#
## set the lin
#export LD=${TOOLCHAIN}/bin/${PLATFORMABI_TOOLCHAIN}'-'ld
## set linker flags
## substitute PF as a special variable from LDEXTRA
#export LDFLAGS="-L${TOOLCHAIN}/sysroot/usr/lib/${PLATFORMABI_TOOLCHAIN}/${LEVEL} ${LDEXTRA/PF/$PLATFORMABI}"

#echo "LDFLAGS: ${LDFLAGS}"
## set the archive index generator tool
#export RANLIB=${TOOLCHAIN}/bin/${PLATFORMABI_TOOLCHAIN}'-'ranlib
## set the symbol stripping tool
#export STRIP=${TOOLCHAIN}/bin/${PLATFORMABI_TOOLCHAIN}'-'strip
#
#echo "Checking compilers.."
#[[ -f ${AR} ]] && echo "ar: ${AR} is ok"
#[[ -f ${AS} ]] && echo "as: ${AS} is ok"
#[[ -f ${CC} ]] && echo "cc: ${CC} is ok"
#[[ -f ${CXX} ]] && echo "c++: ${CXX} is ok"
#[[ -f ${LD} ]] && echo "ld: ${LD} is ok"
#[[ -f ${RANLIB} ]] && echo "ranlib: ${RANLIB} is ok"
#[[ -f ${STRIP} ]] && echo "strip: ${STRIP} is ok"

cd ${SRCDIR}
cargo ndk --target ${PLATFORMABI} --android-platform ${LEVEL} -- build ${CARGO_FLAGS}