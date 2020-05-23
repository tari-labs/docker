#!/bin/bash
PLATFORMS=$1
LEVEL=$2
SRCDIR=$3

for level in ${LEVEL}; do
  for platform in ${PLATFORMS}; do
    /scripts/build_jnilib.sh ${platform} ${LEVEL} ${SRCDIR}
  done
done
