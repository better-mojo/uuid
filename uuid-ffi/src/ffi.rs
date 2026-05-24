use safer_ffi::prelude::*;
use std::ffi::CString;
use uuid::Uuid;

/// 调试输出开关，可以通过环境变量控制
const DEBUG_ENABLED: bool = cfg!(debug_assertions);

#[inline]
fn debug_print(msg: &str) {
    if DEBUG_ENABLED {
        println!("{}", msg);
    }
}

#[ffi_export]
/// 生成新的 UUIDv4
pub fn rs_uuid_v4() -> char_p::Box {
    let id = Uuid::new_v4().to_string();
    debug_print(&format!("rust > uuid v4: {}", id));
    id.try_into().unwrap()
}

#[ffi_export]
/// 生成新的 UUIDv4 到预分配缓冲区
/// 
/// # Safety
/// - result 必须指向至少 size 字节的可用内存
/// - size 必须至少为 37（36字符 + null终止符）
/// 
/// # 返回值
/// - 成功：返回写入的字节数（包括 null 终止符，即 37）
/// - 失败：返回 0（缓冲区太小）
pub fn rs_gen_uuid_v4(result: *mut u8, size: usize) -> usize {
    let id = Uuid::new_v4().to_string();
    debug_print(&format!("rust > uuid v4: {}", id));

    let c_str = CString::new(id).unwrap();
    let bytes = c_str.as_bytes_with_nul(); // 包含 null 终止符

    // size 判断, 包括空字符
    if size < bytes.len() {
        eprintln!("rust > buffer size (min = 37) too small for UUIDv4");
        return 0; // 返回错误码表示缓冲区太小
    }

    let copy_size = size.min(bytes.len());

    unsafe {
        std::ptr::copy_nonoverlapping(bytes.as_ptr(), result, copy_size);
    }

    copy_size // 返回实际写入的字节数（包括 null 终止符）
}

#[ffi_export]
/// 生成新的 UUIDv7
pub fn rs_uuid_v7() -> char_p::Box {
    let id = Uuid::now_v7().to_string();
    debug_print(&format!("rust > uuid v7: {}", id));
    id.try_into().unwrap()
}

#[ffi_export]
/// 生成新的 UUIDv7 到预分配缓冲区
/// 
/// # Safety
/// - result 必须指向至少 size 字节的可用内存
/// - size 必须至少为 37（36字符 + null终止符）
/// 
/// # 返回值
/// - 成功：返回写入的字节数（包括 null 终止符，即 37）
/// - 失败：返回 0（缓冲区太小）
pub fn rs_gen_uuid_v7(result: *mut u8, size: usize) -> usize {
    let id = Uuid::now_v7().to_string();
    debug_print(&format!("rust > uuid v7: {}", id));

    let c_str = CString::new(id).unwrap();
    let bytes = c_str.as_bytes_with_nul();

    // size 判断, 包括空字符
    if size < bytes.len() {
        eprintln!("rust > buffer size (min = 37) too small for UUIDv7");  // 修复：UUIDv4 -> UUIDv7
        return 0; // 返回错误码表示缓冲区太小
    }

    let copy_size = size.min(bytes.len());

    unsafe {
        std::ptr::copy_nonoverlapping(bytes.as_ptr(), result, copy_size);
    }

    copy_size // 返回实际写入的字节数（包括 null 终止符）
}

/// Frees a Rust-allocated string.
#[ffi_export]
pub fn free_rs_string(string: char_p::Box) {
    let str = string.to_str();
    debug_print(&format!("rust > freeing string: {:?}", str));
    drop(string)
}

#[ffi_export]
/// 格式化 UUID 字节数组为字符串
/// 
/// # Arguments
/// - bytes: 16字节的 UUID 字节数组
/// 
/// # Returns
/// - 成功：UUID 字符串
/// - 失败："invalid_uuid"
pub fn uuid_to_string(bytes: &[u8; 16]) -> char_p::Box {
    match Uuid::from_slice(bytes) {
        Ok(uuid) => uuid.to_string().try_into().unwrap(),
        Err(_) => "invalid_uuid".to_string().try_into().unwrap(),
    }
}

#[ffi_export]
/// 解析 UUID 字符串为字节数组
/// 
/// # Arguments
/// - uuid_str: UUID 字符串
/// - result: 输出缓冲区，必须至少 16 字节
/// 
/// # Returns
/// - 成功：0
/// - 失败：-1（格式错误）
pub fn uuid_parse(uuid_str: char_p::Ref<'_>, result: *mut u8) -> i32 {
    let s = uuid_str.to_str();
    match Uuid::parse_str(s) {
        Ok(uuid) => {
            let bytes = uuid.as_bytes();
            unsafe {
                std::ptr::copy_nonoverlapping(bytes.as_ptr(), result, 16);
            }
            0
        }
        Err(_) => -1,
    }
}

#[ffi_export]
/// 获取 UUID 版本号
/// 
/// # Arguments
/// - uuid_str: UUID 字符串
/// 
/// # Returns
/// - 成功：版本号 (1-8)
/// - 失败：-1（格式错误或 nil UUID）
pub fn uuid_version(uuid_str: char_p::Ref<'_>) -> i32 {
    let s = uuid_str.to_str();
    match Uuid::parse_str(s) {
        Ok(uuid) => uuid.get_version_num() as i32,
        Err(_) => -1,
    }
}

#[ffi_export]
/// 验证字符串是否为有效的 UUID
/// 
/// # Arguments
/// - uuid_str: 要验证的字符串
/// 
/// # Returns
/// - 有效：1
/// - 无效：0
pub fn uuid_validate(uuid_str: char_p::Ref<'_>) -> i32 {
    let s = uuid_str.to_str();
    match Uuid::parse_str(s) {
        Ok(_) => 1,
        Err(_) => 0,
    }
}

#[ffi_export]
/// 比较两个 UUID
/// 
/// # Arguments
/// - uuid1: 第一个 UUID 字符串
/// - uuid2: 第二个 UUID 字符串
/// 
/// # Returns
/// - uuid1 < uuid2: -1
/// - uuid1 == uuid2: 0
/// - uuid1 > uuid2: 1
/// - 解析错误: -2
pub fn uuid_compare(uuid1: char_p::Ref<'_>, uuid2: char_p::Ref<'_>) -> i32 {
    let s1 = uuid1.to_str();
    let s2 = uuid2.to_str();
    
    match (Uuid::parse_str(s1), Uuid::parse_str(s2)) {
        (Ok(u1), Ok(u2)) => {
            match u1.cmp(&u2) {
                std::cmp::Ordering::Less => -1,
                std::cmp::Ordering::Equal => 0,
                std::cmp::Ordering::Greater => 1,
            }
        }
        _ => -2,
    }
}

#[ffi_export]
/// 批量生成 UUIDv4
/// 
/// # Arguments
/// - results: 输出缓冲区，大小必须为 count * 37 字节
/// - count: 要生成的 UUID 数量
/// - buf_size: 缓冲区总大小
/// 
/// # Returns
/// - 成功：实际生成的 UUID 数量
/// - 失败：0（缓冲区太小）
pub fn rs_gen_uuid_v4_batch(
    results: *mut u8,
    count: usize,
    buf_size: usize,
) -> usize {
    let uuid_size = 37usize; // 36字符 + null终止符
    let required_size = count * uuid_size;
    
    if buf_size < required_size {
        eprintln!("rust > buffer size too small for batch generation");
        return 0;
    }
    
    let mut generated = 0;
    
    for i in 0..count {
        let id = Uuid::new_v4().to_string();
        let c_str = CString::new(id).unwrap();
        let bytes = c_str.as_bytes_with_nul();
        
        unsafe {
            let offset = i * uuid_size;
            std::ptr::copy_nonoverlapping(
                bytes.as_ptr(),
                results.add(offset),
                uuid_size
            );
        }
        generated += 1;
    }
    
    generated
}

#[ffi_export]
/// 批量生成 UUIDv7
/// 
/// # Arguments
/// - results: 输出缓冲区，大小必须为 count * 37 字节
/// - count: 要生成的 UUID 数量
/// - buf_size: 缓冲区总大小
/// 
/// # Returns
/// - 成功：实际生成的 UUID 数量
/// - 失败：0（缓冲区太小）
pub fn rs_gen_uuid_v7_batch(
    results: *mut u8,
    count: usize,
    buf_size: usize,
) -> usize {
    let uuid_size = 37usize; // 36字符 + null终止符
    let required_size = count * uuid_size;
    
    if buf_size < required_size {
        eprintln!("rust > buffer size too small for batch generation");
        return 0;
    }
    
    let mut generated = 0;
    
    for i in 0..count {
        let id = Uuid::now_v7().to_string();
        let c_str = CString::new(id).unwrap();
        let bytes = c_str.as_bytes_with_nul();
        
        unsafe {
            let offset = i * uuid_size;
            std::ptr::copy_nonoverlapping(
                bytes.as_ptr(),
                results.add(offset),
                uuid_size
            );
        }
        generated += 1;
    }
    
    generated
}

/// The following test function is necessary for the header generation.
#[::safer_ffi::cfg_headers]
#[test]
pub fn generate_headers() -> ::std::io::Result<()> {
    ::safer_ffi::headers::builder()
        .with_language(safer_ffi::ඞ::Language::Python)
        .to_file("py.cffi")?
        .generate()?;

    ::safer_ffi::headers::builder()
        .to_file("cffi.h")?
        .generate()?;

    Ok(())
}

//
// use in gen/gen.rs
//
pub fn generate() -> ::std::io::Result<()> {
    ::safer_ffi::headers::builder()
        .with_language(safer_ffi::ඞ::Language::Python)
        .to_file("py.cffi")?
        .generate()?;

    ::safer_ffi::headers::builder()
        .to_file("cffi.h")?
        .generate()?;

    Ok(())
}

// 单元测试模块
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_uuid_v4_generate() {
        let uuid_str = rs_uuid_v4();
        let rust_str = uuid_str.to_string();
        assert_eq!(rust_str.len(), 36);
        assert!(Uuid::parse_str(&rust_str).is_ok());
    }

    #[test]
    fn test_uuid_v7_generate() {
        let uuid_str = rs_uuid_v7();
        let rust_str = uuid_str.to_string();
        assert_eq!(rust_str.len(), 36);
        assert!(Uuid::parse_str(&rust_str).is_ok());
    }

    #[test]
    fn test_uuid_parse() {
        let valid = char_p::new("67e55044-10b1-426f-9247-bb680e5fe0c8");
        let mut buffer = [0u8; 16];
        assert_eq!(uuid_parse(valid.as_ref(), buffer.as_mut_ptr()), 0);
        
        let invalid = char_p::new("invalid-uuid");
        assert_eq!(uuid_parse(invalid.as_ref(), buffer.as_mut_ptr()), -1);
    }

    #[test]
    fn test_uuid_validate() {
        let valid = char_p::new("67e55044-10b1-426f-9247-bb680e5fe0c8");
        assert_eq!(uuid_validate(valid.as_ref()), 1);
        
        let invalid = char_p::new("not-a-uuid");
        assert_eq!(uuid_validate(invalid.as_ref()), 0);
    }

    #[test]
    fn test_uuid_version() {
        let v4 = char_p::new("550e8400-e29b-41d4-a716-446655440000");
        assert_eq!(uuid_version(v4.as_ref()), 4);
        
        // UUIDv7 example
        let v7 = char_p::new("018f3b3c-7e6b-7b3a-8b3a-3c7e6b7b3a8b");
        assert_eq!(uuid_version(v7.as_ref()), 7);
    }

    #[test]
    fn test_uuid_compare() {
        let uuid1 = char_p::new("00000000-0000-0000-0000-000000000001");
        let uuid2 = char_p::new("00000000-0000-0000-0000-000000000002");
        let uuid3 = char_p::new("00000000-0000-0000-0000-000000000001");
        
        assert_eq!(uuid_compare(uuid1.as_ref(), uuid2.as_ref()), -1);
        assert_eq!(uuid_compare(uuid2.as_ref(), uuid1.as_ref()), 1);
        assert_eq!(uuid_compare(uuid1.as_ref(), uuid3.as_ref()), 0);
    }

    #[test]
    fn test_uuid_to_string() {
        let bytes = [
            0x12u8, 0x3e, 0x45, 0x67, 0x98, 0xab, 0xcd, 0xef,
            0x12, 0x34, 0x56, 0x78, 0x90, 0x12, 0x34, 0x56,
        ];

        let uuid_str = uuid_to_string(&bytes);
        assert_eq!(uuid_str.to_string(), "123e4567-98ab-cdef-1234-567890123456");
    }

    #[test]
    fn test_gen_uuid_v4_buffer() {
        let mut buffer = [0u8; 37];
        let size = rs_gen_uuid_v4(buffer.as_mut_ptr(), buffer.len());
        assert_eq!(size, 37);
        
        // 转换为字符串并验证
        let c_str = unsafe { std::ffi::CStr::from_ptr(buffer.as_ptr() as *const i8) };
        let s = c_str.to_str().unwrap();
        assert_eq!(s.len(), 36);
        assert!(Uuid::parse_str(s).is_ok());
    }

    #[test]
    fn test_gen_uuid_v4_batch() {
        let count = 10;
        let buf_size = count * 37;
        let mut buffer = vec![0u8; buf_size];
        
        let generated = rs_gen_uuid_v4_batch(
            buffer.as_mut_ptr(),
            count,
            buf_size
        );
        
        assert_eq!(generated, count);
        
        // 验证每个 UUID
        for i in 0..count {
            let offset = i * 37;
            let c_str = unsafe {
                std::ffi::CStr::from_ptr(buffer.as_ptr().add(offset) as *const i8)
            };
            let s = c_str.to_str().unwrap();
            assert!(Uuid::parse_str(s).is_ok());
        }
    }
}
