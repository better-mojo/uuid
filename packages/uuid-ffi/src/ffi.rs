use std::ffi::CString;
use uuid::Uuid;


#[repr(C)]
#[derive(Debug)]
pub struct Str {
    pub data: String,
}


#[no_mangle]
pub extern "C" fn new_v4() -> Str {
    let uuid = Uuid::new_v4();

    // 将 UUID 转换为字符串
    let uuid_str = uuid.to_string();

    Str { data: uuid_str }

    // 将字符串转换为 C 字符串
    // let c_str = CString::new(uuid_str).unwrap();
    // c_str.into_raw()
}


#[no_mangle]
pub extern "C" fn now_v7() -> CString {
    let uuid = Uuid::now_v7();

    // 将 UUID 转换为字符串
    let uuid_str = uuid.to_string();
    CString::new(uuid_str).unwrap()
}


#[cfg(test)]
mod tests {
    #[test]
    fn new_v4() {
        let result = new_v4();
        println!("result: {:?}", result);
    }
}
