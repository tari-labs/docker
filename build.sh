#!/usr/bin/env bash
docker build -t quay.io/tarilabs/rust:1.30 ./rust/slim
docker build -t quay.io/tarilabs/rust:1.30-alpine ./rust/alpine/
docker build -t quay.io/tarilabs/run:alpine ./run/alpine/