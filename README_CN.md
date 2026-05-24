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

## 开发环境

### 安装依赖

- 安装 [Taskfile](https://github.com/go-task/go-task) ： 编译构建工具
- 安装 [Rust](https://www.rust-lang.org/tools/install)
- 安装 [pixi](https://pixi.sh/)
- 安装 [rattler-build](https://rattler-build.prefix.dev/latest/#installation) ： 包管理工具，编译+发布 rust 二进制包
- 安装 [mojo](https://mojolang.org/install/)

```ruby
task setup
```

### 编译调试

- ✅ 编译调试 uuid-ffi 包

```ruby

# 运行示例
task ffi:r

# 编译 uuid-ffi 包
task ffi:b

# release uuid-ffi 包
task ffi:rel

```

- ✅ 编译调试 uuid [examples](./examples) 示例

```ruby
# 运行 examples 示例
task uuid:r

```

## 发布到 Prefix.dev

- ✅ <https://prefix.dev/channels/better-ffi>
- ✅ <https://prefix.dev/channels/better-mojo>
- ✅ [Taskfile](./Taskfile.yml)

```bash

# 发布
task release:rs
task release:mojo

# 发布到 prefix.dev
task publish:ffi
task publish:mojo

```

- ✅ 编译发布 Linux 版本， 基于 `orbstack` 虚拟机
  - 注意，每次都要把 ffi 库，`3 个 OS 版本`，都发布到 prefix.dev，再发布 uuid 包。（依赖顺序）

```bash
# 查看可用的虚拟机
orbctl list 

# 连接 linux-aarch64 架构的 虚拟机, 执行编译+发布
orbctl run -m u22dev

# 连接 linux-64 架构的 虚拟机, 执行编译+发布
orbctl run -m u22build

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
