#!/usr/bin/env bash
echo $VER
docker build -t quay.io/tarilabs/rust:1.31 ./rust/slim
docker build -t quay.io/tarilabs/rust:1.30-alpine ./rust/alpine/
docker build -t quay.io/tarilabs/run:alpine-1.36 ./run/alpine/
# The nightly version
docker build -t quay.io/tarilabs/rust_tari-build-with-deps:nightly-2019-07-15 ./rust/build/
