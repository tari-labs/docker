# docker

Base docker containers

# run

Minimal containers for running Rust binaries (required lib packages included)

# rust

Containers for building rust applications

# Building quay image dependencies for build-libwallet github action

- Note: `sudo` may be required to run docker on Windows/WSL \*

```bash
# in rust/build/
docker build -t quay.io/tarilabs/rust_tari-build-with-deps:nightly-2021-09-18 .

# in ndk-build/
docker build -t quay.io/tarilabs/rust-ndk:1.57.0_r21b .

# in sqlite-mobile/
docker build -t quay.io/tarilabs/sqlite-mobile:201911192122 .

# in ssl-mobile/
docker build -t quay.io/tarilabs/openssl-android:202101052000 .
```
