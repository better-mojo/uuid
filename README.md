## 本项目已经归档, 已经迁移到: https://github.com/better-mojo/disc
## 本项目已经归档, 已经迁移到: https://github.com/better-mojo/disc
## 本项目已经归档, 已经迁移到: https://github.com/better-mojo/disc




---

#
#














# uuid

binding a `mojo` version of [rust uuid](https://github.com/uuid-rs/uuid).

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

- https://prefix.dev/channels/better-ffi
- https://prefix.dev/channels/better-mojo

| Project                             | Package                 | Rank   | Description                              |
|-------------------------------------|-------------------------|--------|------------------------------------------|
| ✅ [uuid-ffi](./packages/uuid-ffi)   | [libuuid_ffi][uuid-ffi] | ⭐️⭐️⭐️ | uuid-rs ffi                              |
| ✅ [uuid-gen](./packages/uuid-gen)   | *                       | ⭐️     | generate `mojo abi` from `uuid-ffi-core` |
| ✅ [uuid-mojo](./packages/uuid-mojo) | [uuid_mojo][uuid-mojo]  | ⭐️     | uuid-mojo package                        |


## Usage

- [examples](./packages/uuid-mojo/examples)

- api:

```mojo
from uuid_mojo import new_v4, new_v7, new_v4_2, version

fn main():
    var v = version()
    print(v)
    print(new_v4())
    print(new_v4_2())

```

## Reference

### uuid-rs

- ✅ https://crates.io/crates/uuid
- ✅ https://github.com/uuid-rs/uuid
    - [examples](https://github.com/uuid-rs/uuid/tree/main/examples)

### Rust FFI

- ✅ https://github.com/f0cii/diplomat
    - https://github.com/rust-diplomat/diplomat
    - https://rust-diplomat.github.io/book/
- ✅ https://github.com/mozilla/uniffi-rs
- ✅ https://rustwiki.org/zh-CN/std/ffi/struct.CString.html#examples

[language-shield]: https://img.shields.io/badge/Mojo%F0%9F%94%A5-24.5-orange

[license-shield]: https://img.shields.io/github/license/better-mojo/jojo?logo=github

[license-url]: https://github.com/better-mojo/jojo/blob/main/LICENSE

[contributors-shield]: https://img.shields.io/badge/contributors-welcome!-blue

[contributors-url]: https://github.com/better-mojo/uuid#contributing

[uuid-ffi]: https://prefix.dev/channels/better-ffi/packages/libuuid_ffi

[uuid-mojo]: https://prefix.dev/channels/better-mojo/packages/uuid_mojo




