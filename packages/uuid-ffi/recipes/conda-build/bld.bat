:: 使用 cargo 构建 Rust 库
cargo build --release

:: 创建目标目录
mkdir %PREFIX%\lib
mkdir %PREFIX%\include

:: 复制生成的库文件到目标路径
copy target\release\xxx.lib %PREFIX%\lib\

:: 复制头文件（如果有）
:: copy include\xxx.h %PREFIX%\include\
