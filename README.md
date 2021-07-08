# docker
Base docker containers

# run

Minimal containers for running Rust binaries (required lib packages included)

# rust

Containers for building rust applications

# Building quay image dependencies for build-libwallet github action

```
cd rust
cd build
docker build -t quay.io/tarilabs/rust_tari-build-with-deps:nightly-2021-05-09 .
cd ../..
cd ndk-build/
docker build -t quay.io/tarilabs/rust-ndk:1.53.0_r21b .
cd ..
cd sqlite-mobile/
docker build -t quay.io/tarilabs/sqlite-mobile:201911192122 .
cd ..
cd ssl-mobile/
docker build -t quay.io/tarilabs/openssl-android:202101052000 .
```
