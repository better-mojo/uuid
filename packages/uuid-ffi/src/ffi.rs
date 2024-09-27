use std::ffi::{c_void, CString};
use std::os::raw::c_char;
use uuid::Uuid;


#[no_mangle]
pub extern "C" fn new_v4() -> *const c_char {
    let uuid = Uuid::new_v4().to_string();

    println!("uuid: {:?}", uuid);

    let c_string = CString::new(uuid).unwrap().into_raw();
    // CString::new(uuid).unwrap().as_ptr()

    // 手动释放内存
    unsafe {
        let _ = libc::free(c_string as *mut c_void);
    }

    c_string
}


#[no_mangle]
pub extern "C" fn now_v7() -> *const c_char {
    let uuid = Uuid::now_v7().to_string();

    // 将 UUID 转换为字符串
    println!("uuid: {:?}", uuid);
    let c_string = CString::new(uuid).unwrap().into_raw();

    // 手动释放内存
    unsafe {
        let _ = libc::free(c_string as *mut c_void);
    }

    c_string
}


#[cfg(test)]
mod tests {
    #[test]
    fn new_v4() {
        let result = new_v4();
        println!("result: {:?}", result);
    }
}
