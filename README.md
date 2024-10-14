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

| Project                           | Package                 | Rank   | Description |
|-----------------------------------|-------------------------|--------|-------------|
| [uuid-ffi](./packages/uuid-ffi)   | [libuuid_ffi][uuid-ffi] | ⭐️⭐️⭐️ | uuid-rs ffi |
| [uuid-mojo](./packages/uuid-mojo) | [uuid_mojo][uuid-mojo]  | ⭐️     | uuid-mojo   |

## Installation

## Quick Start

1. Add the `better-ffi, better-mojo` channel to your `mojoproject.toml`, e.g:
   ```toml
   [project]
   channels = ["conda-forge", "https://conda.modular.com/max", "https://repo.prefix.dev/better-ffi",  "https://repo.prefix.dev/better-mojo", ]
   ```

or use [magic](https://docs.modular.com/magic/):

```ruby
magic project channel add "https://repo.prefix.dev/better-ffi" 
magic project channel add "https://repo.prefix.dev/better-mojo" 
```

- add `uuid` to your `dependencies`

```ruby
magic add uuid_mojo
magic add libuuid_ffi
 
 
# pixi add libuuid_ffi
```

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

- https://crates.io/crates/uuid
- https://github.com/uuid-rs/uuid
    - [examples](https://github.com/uuid-rs/uuid/tree/main/examples)

> rust ffi, c str

- https://rustwiki.org/zh-CN/std/ffi/struct.CString.html#examples

[language-shield]: https://img.shields.io/badge/Mojo%F0%9F%94%A5-24.5-orange

[license-shield]: https://img.shields.io/github/license/better-mojo/jojo?logo=github

[license-url]: https://github.com/better-mojo/jojo/blob/main/LICENSE

[contributors-shield]: https://img.shields.io/badge/contributors-welcome!-blue

[contributors-url]: https://github.com/better-mojo/uuid#contributing

[uuid-ffi]: https://prefix.dev/channels/better-ffi/packages/libuuid_ffi

[uuid-mojo]: https://prefix.dev/channels/better-mojo/packages/uuid_mojo




