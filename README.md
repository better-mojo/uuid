# uuid

Binding a `mojo` version of [rust uuid](https://github.com/uuid-rs/uuid).

<a name="readme-top"></a>

<!-- PROJECT LOGO -->
<br />
<div align="center">

<h3 align="center">UUID Mojo</h3>

  <p align="center">
    🐝 binding uuid-rs for mojo 🔥
    <br/>

![Mojo Version][language-shield]
[![MIT License][license-shield]][license-url]
[![Pixi Badge](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/prefix-dev/pixi/main/assets/badge/v0.json)](https://pixi.sh)
<br/>
[![Contributors Welcome][contributors-shield]][contributors-url]

[简体中文](README_CN.md) | English

  </p>
</div>

## Includes

| Project                             | Package                 | Host | Rank   | Description                              |
|-------------------------------------|-------------------------|------|--------|------------------------------------------|
| ✅ [uuid-ffi](./uuid-ffi)   | [libuuid_ffi](https://prefix.dev/channels/better-ffi/packages/libuuid_ffi) | [prefix.dev](https://prefix.dev/channels/better-ffi) | ⭐️⭐️⭐️ | uuid-rs ffi package                      |
| ✅ [uuid](./uuid) | [uuid](https://prefix.dev/channels/better-mojo/packages/uuid)  | [prefix.dev](https://prefix.dev/channels/better-mojo) | ⭐️⭐️⭐️⭐️   | uuid-mojo package                        |

## Usage

- Import dependencies:

```toml

# First add 2 channel sources, including uuid-ffi package and uuid package
channels = [
    "https://conda.modular.com/max-nightly",
    "https://repo.prefix.dev/better-ffi", # contains uuid-ffi package
    "https://repo.prefix.dev/better-mojo", # contains uuid mojo package
    "conda-forge",
]

# Add 2 dependency packages, including uuid-ffi package and uuid package
[dependencies]
mojo = ">=1.0.0b2.dev2026052215,<2"

# FFI dependency
libuuid_ffi = ">=0.2.4,<0.3"
# Mojo package dependency
uuid = ">=0.2.5,<0.3"

```

- ✅ Simple example:

```mojo
import uuid


def test_uuid() raises:
    # implement style 1:
    var id = uuid.uuid_v4()  # auto free memory
    var id2 = uuid.uuid_v7()  # auto free memory

    # implement style 2:
    var id3 = uuid.gen_uuid_v4()
    var id4 = uuid.gen_uuid_v7()  # auto free memory

    print(id)
    print(id2)

    print(id3)
    print(id4)


def main() raises:
    test_uuid()

```

- ✅ Complete example [examples/try-uuid](examples/try-uuid)
  - Includes complete package dependency import methods

```bash
# install dependencies
pixi install

# run
pixi run mojo src/main.mojo

```

## Development Environment

### Install Dependencies

- Install [Taskfile](https://github.com/go-task/go-task): build tool
- Install [Rust](https://www.rust-lang.org/tools/install)
- Install [pixi](https://pixi.sh/)
- Install [rattler-build](https://rattler-build.prefix.dev/latest/#installation): package management tool, compile + publish rust binary packages
- Install [mojo](https://mojolang.org/install/)

```bash
task setup
```

### Build and Debug

- ✅ Build and debug uuid-ffi package

```bash

# run examples
task ffi:r

# build uuid-ffi package
task ffi:b

# release uuid-ffi package
task ffi:rel

```

- ✅ Build and debug uuid [examples](./examples)

```bash
# run examples
task uuid:r

```

## Release and Publish to Prefix.dev

- ✅ <https://prefix.dev/channels/better-ffi>
- ✅ <https://prefix.dev/channels/better-mojo>
- ✅ [Taskfile](./Taskfile.yml)

```bash

# release
task release:rs
task release:mojo

# publish to prefix.dev
task publish:ffi
task publish:mojo

```

- ✅ Compile and release Linux version, based on `orbstack` virtual machine
  - Note: each time you need to publish the ffi library for `3 OS versions` to prefix.dev first, then publish the uuid package. (dependency order)

```bash
# list available virtual machines
orbctl list 

# connect to linux-aarch64 architecture virtual machine, execute compile + publish
orbctl run -m u22dev

# connect to linux-64 architecture virtual machine, execute compile + publish
orbctl run -m u22build

```

## Reference

### Mojo + SQLite

- ✅ <https://github.com/ehsanmok/sqlite>

### uuid-rs

- ✅ <https://crates.io/crates/uuid>
- ✅ <https://github.com/uuid-rs/uuid>
  - [examples](https://github.com/uuid-rs/uuid/tree/main/examples)

### Rust FFI

- ✅ <https://github.com/getditto/safer_ffi>
- ✅ <https://github.com/f0cii/diplomat>
  - <https://github.com/rust-diplomat/diplomat>
  - <https://rust-diplomat.github.io/book/>
- ✅ <https://github.com/mozilla/uniffi-rs>
- ✅ <https://rustwiki.org/zh-CN/std/ffi/struct.CString.html#examples>

[language-shield]: https://img.shields.io/badge/Mojo%F0%9F%94%A5-1.0.0b2-orange

[license-shield]: https://img.shields.io/github/license/better-mojo/jojo?logo=github

[license-url]: https://github.com/better-mojo/jojo/blob/main/LICENSE

[contributors-shield]: https://img.shields.io/badge/contributors-welcome!-blue

[contributors-url]: https://github.com/better-mojo/uuid#contributing
