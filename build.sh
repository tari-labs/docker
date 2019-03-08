#!/usr/bin/env bash
echo $VER
docker build -t quay.io/tarilabs/rust:1.31 ./rust/slim
docker build -t quay.io/tarilabs/rust:1.30-alpine ./rust/alpine/
docker build -t quay.io/tarilabs/run:alpine ./run/alpine/
# The nightly version
docker build -t quay.io/tarilabs/rust_tari-build-zmq:nightly-2019-03-08 ./rust/build/