#!/bin/bash

# Converts a rust option from the config file format into the corresponding env variable name
# E.G.  "target.x86_64-unknown-linux-gnu.runner" => "CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_RUNNER"
function argify() {
  arg=$1
  arg=${arg^^}
  arg=${arg//-/_}
  arg=CARGO_${arg//./_}
}

# Build a native library for the given platform.
# Assume source code resides at SRC_DIR
PLATFORMABI=$1
LEVEL=$2
SRCDIR=$3

set -e

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

# set the linker
export LD=${NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin/${PLATFORMABI_TOOLCHAIN}$'-'ld
echo "Linker ${LD}"

# set the archive index generator tool
export RANLIB=${NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin/${PLATFORMABI_TOOLCHAIN}$'-'ranlib
echo "Archive Indexer: ${RANLIB}"

# set the symbol stripping tool
export STRIP=${NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin/${PLATFORMABI_TOOLCHAIN}$'-'strip
echo "Symbol Stripper: ${STRIP}"

echo ""
export CXXFLAGS="-stdlib=libstdc++ -isystem ${NDK_HOME}/sources/cxx-stl/llvm-libc++/include"
echo "CXX Flags: ${CXXFLAGS}"

export CFLAGS="${CFLAGS//PF/$PLATFORMABI} -I${NDK_HOME}/sources/cxx-stl/llvm-libc++/include -I${NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include -I${NDK_HOME}/sysroot/usr/include/${PLATFORMABI}"
echo "CFLAGS: ${CFLAGS}"

export LDFLAGS="-L${NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/${PLATFORMABI_TOOLCHAIN}/${LEVEL} ${LDFLAGS//PF/$PLATFORMABI}"
echo "LDFLAGS: ${LDFLAGS}"

export CPPFLAGS="${CPPFLAGS//PF/$PLATFORMABI}"
echo "CPPFLAGS: ${CPPFLAGS}"

echo "Sqlite:"
objdump -f /platforms/platforms/${PLATFORMABI}/lib/libsqlite3.a # Note: Path issue from sqlite_mobile

export RUSTFLAGS="-L/platforms/platforms/${PLATFORMABI}/lib/" # Note: Path issue from sqlite_mobile
echo "RUSTFLAGS: ${RUSTFLAGS}"

export CARGO_BUILD_TARGET="${PLATFORMABI}"
echo "Cargo target: ${CARGO_BUILD_TARGET}"

echo "Rust config:"
mkdir -p /build/${PLATFORM_OUTDIR}

#export CARGO_TARGET_DIR=/build/${PLATFORM_OUTDIR} # Note: diesel_migrations v1.4.0 will not compile with this.
#echo "Output directory: ${CARGO_TARGET_DIR}"

argify "target.${PLATFORMABI}.ar"
export $arg="${AR}"
echo $arg="${AR}"
argify "target.${PLATFORMABI}.linker"
export $arg="${CC}"
echo $arg="${CC}"
argify "target.${PLATFORMABI}.rustflags"
export ${arg}="${RUSTFLAGS}"
echo ${arg}="${RUSTFLAGS}"

cd ${SRCDIR}/base_layer/wallet_ffi # Note: Possibly pass this in as ${project_root}? Without it all crates are
                                   # downloaded and compiled instead of the compatible subset.
                                   # Without it croaring breaks in the build (it should be excluded for mobile).

# Build rust build!
cargo clean
cargo build ${CARGO_FLAGS}
cp ${SRCDIR}/target/${PLATFORMABI}/release/libtari_wallet_ffi.a /build/${PLATFORM_OUTDIR}
objdump -f /build/${PLATFORM_OUTDIR}/libtari_wallet_ffi.a
# Compiled library will be in build/{platform}