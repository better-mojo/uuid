#!/bin/bash

# 使用 cargo 构建 Rust 库
cargo build --release --lib

# 创建目标目录
mkdir -p $PREFIX/lib
mkdir -p $PREFIX/include

# 复制构建生成的库文件到目标路径
cp target/release/libxxx.a $PREFIX/lib/
cp target/release/libxxx.dylib $PREFIX/lib/
cp target/release/libxxx.so $PREFIX/lib/

# 如果需要将库的头文件（如果有）安装到 include 目录
# cp include/xxx.h $PREFIX/include/
