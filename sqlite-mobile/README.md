# sqlite-mobile image

The mobile applications for Tari require a dynamically linked version of SQLite.

This image hosts a prebuilt set of binaries for various mobile platforms.

The binaries are copied to `/platforms/sqlite/{PLATFORM}`

By default the platforms are

* x86_64-linux-android - Android emulators
* aarch64-linux-android - 64-bit ARMv8 chipsets
* armv7-linux-androideabi - 32-bit ARMv7 chipssets

You can override the platform set when building the image by setting the PLATFORM arg:

`docker build --build-arg PLATFORM="x86_64-linux-android" -t sqlite_mobile:x86_64 ./sqlite-mobile/slim`

The default set of arguments produces this output in the root folder of the image:

```
`-- sqlite
    |-- aarch64-linux-android
    |   |-- bin
    |   |   `-- sqlite3
    |   |-- include
    |   |   |-- sqlite3.h
    |   |   `-- sqlite3ext.h
    |   |-- lib
    |   |   |-- libsqlite3.a
    |   |   |-- libsqlite3.la
    |   |   |-- libsqlite3.so
    |   |   `-- pkgconfig
    |   |       `-- sqlite3.pc
    |   `-- share
    |       `-- man
    |           `-- man1
    |               `-- sqlite3.1
    |-- armv7-linux-androideabi
    |   |-- bin
    |   |   `-- sqlite3
    |   |-- include
    |   |   |-- sqlite3.h
    |   |   `-- sqlite3ext.h
    |   |-- lib
    |   |   |-- libsqlite3.a
    |   |   |-- libsqlite3.la
    |   |   |-- libsqlite3.so
    |   |   `-- pkgconfig
    |   |       `-- sqlite3.pc
    |   `-- share
    |       `-- man
    |           `-- man1
    |               `-- sqlite3.1
    `-- x86_64-linux-android
        |-- bin
        |   `-- sqlite3
        |-- include
        |   |-- sqlite3.h
        |   `-- sqlite3ext.h
        |-- lib
        |   |-- libsqlite3.a
        |   |-- libsqlite3.la
        |   |-- libsqlite3.so
        |   `-- pkgconfig
        |       `-- sqlite3.pc
        `-- share
            `-- man
                `-- man1
                    `-- sqlite3.1
```
