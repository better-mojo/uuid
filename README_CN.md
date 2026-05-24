# uuid

为 [rust uuid](https://github.com/uuid-rs/uuid) 绑定 Mojo 版本。

<a name="readme-top"></a>

<!-- 项目 LOGO -->
<br />
<div align="center">

<h3 align="center">UUID Mojo</h3>

  <p align="center">
    🐝 为 mojo 绑定 uuid-rs 🔥
    <br/>

![Mojo 版本][language-shield]
[![MIT 许可证][license-shield]][license-url]
[![Pixi 徽章](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/prefix-dev/pixi/main/assets/badge/v0.json)](https://pixi.sh)
<br/>
[![欢迎贡献者][contributors-shield]][contributors-url]

简体中文 | [English](README.md)

  </p>
</div>

## 包内容

- <https://prefix.dev/channels/better-ffi>
- <https://prefix.dev/channels/better-mojo>

| 项目                             | 包                 | 等级   | 描述                              |
|-------------------------------------|-------------------------|--------|------------------------------------------|
| ✅ [uuid-ffi](./uuid-ffi)   | [libuuid_ffi](https://prefix.dev/channels/better-ffi/packages/libuuid_ffi) | ⭐️⭐️⭐️ | uuid-rs ffi                              |
| ✅ [uuid](./uuid) | [uuid](https://prefix.dev/channels/better-mojo/packages/uuid)  | ⭐️     | uuid-mojo 包                        |

## 使用方法

- 导入依赖：

```toml

# 先添加 2 个源地址，包含 uuid-ffi 包和 uuid 包
channels = [
    "https://conda.modular.com/max-nightly",
    "https://repo.prefix.dev/better-ffi", # 包含 uuid-ffi 包
    "https://repo.prefix.dev/better-mojo", # 包含 uuid 包
    "conda-forge",
]

# 添加 2 个依赖包，包含 uuid-ffi 包和 uuid 包
[dependencies]
mojo = ">=1.0.0b2.dev2026052215,<2"

# FFI 依赖
libuuid_ffi = ">=0.2.4,<0.3"
# Mojo 包依赖
uuid = ">=0.2.5,<0.3"

```

- ✅ 简单示例:

```mojo
import uuid


def test_uuid() raises:
    # 实现方式 1:
    var id = uuid.uuid_v4()  # 自动释放内存
    var id2 = uuid.uuid_v7()  # 自动释放内存

    # 实现方式 2:
    var id3 = uuid.gen_uuid_v4()
    var id4 = uuid.gen_uuid_v7()  # 自动释放内存

    print(id)
    print(id2)

    print(id3)
    print(id4)


def main() raises:
    test_uuid()

```

- ✅  完整示例 [examples/try-uuid](examples/try-uuid)
  - 包含完整的包依赖导入方法

```bash
# 安装依赖
pixi install

# 运行
pixi run mojo src/main.mojo

```

## 发布到 Prefix.dev

- ✅ [Taskfile](./Taskfile.yml)

```bash

# 发布
task release:rs
task release:mojo

# 发布到 prefix.dev
task publish:ffi
task publish:mojo

```

## 参考

### Mojo + SQLite

- ✅ <https://github.com/ehsanmok/sqlite>

### uuid-rs

- ✅ <https://crates.io/crates/uuid>
- ✅ <https://github.com/uuid-rs/uuid>
  - [示例](https://github.com/uuid-rs/uuid/tree/main/examples)

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
