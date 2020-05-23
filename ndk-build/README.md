## Rust Android NDK build environment

This image contains the Rust compoiler and the Android NDK allowing one to build JNI libraries for Android

## Environment variables

You can set any of the following environment variables to drive the compilers:

| Flag        | Default | Description                                           |
|:------------|:--------|:------------------------------------------------------|
| LDEXTRA     | ""      | Extra flags to be appended to LDFLAGS                 |
| CFLAGS      | ""      | Flags passed to C compiler                            |
| CPPFLAGS    | ""      | Flags passed to C compiler                            |
| SRC_DIR     | /src    | The mount point for the source code to compile        |
| CARGO_FLAGS | "'      | Additional flags passed to `cargo`                    |
| LEVEL       | 24      | A space separated set of Android API levels to target |
| PLATFORMS   | *       | The android chipsets to target                        |

\* The default platform set is `"x86_64-linux-android aarch64-linux-android armv7-linux-androideabi i686-linux-android arm-linux-androideabi"`

