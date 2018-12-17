#!/usr/bin/env bash
VER=${1:-1.30}
echo $VER
docker build -t quay.io/tarilabs/rust:$VER ./rust/slim
docker build -t quay.io/tarilabs/rust:1.30-alpine ./rust/alpine/
docker build -t quay.io/tarilabs/run:alpine ./run/alpine/