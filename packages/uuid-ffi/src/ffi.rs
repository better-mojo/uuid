use std::ffi::CString;
use std::os::raw::c_char;
use uuid::Uuid;


#[no_mangle]
pub extern "C" fn new_v4() -> *const c_char {
    let uuid = Uuid::new_v4().to_string();

    println!("uuid: {:?}", uuid);

    CString::new(uuid).unwrap().into_raw()
    // CString::new(uuid).unwrap().as_ptr()

    // 将字符串转换为C字符串
    // let c_str = CStr::from_bytes_with_nul(uuid.as_bytes()).unwrap();
    // CString { ptr: c_str.as_ptr(), len: uuid.len() }
}


#[no_mangle]
pub extern "C" fn now_v7() -> *const c_char {
    let uuid = Uuid::now_v7().to_string();

    // 将 UUID 转换为字符串
    println!("uuid: {:?}", uuid);
    CString::new(uuid).unwrap().into_raw()
}


#[cfg(test)]
mod tests {
    #[test]
    fn new_v4() {
        let result = new_v4();
        println!("result: {:?}", result);
    }
}
