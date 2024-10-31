use std::ffi::{c_void, CString};
use std::os::raw::c_char;
use uuid::Uuid;


#[no_mangle]
pub extern "C" fn new_v4() -> *mut c_char {
    let uuid = Uuid::new_v4().to_string();

    let c_string = CString::new(uuid).unwrap();
    // println!("uuid v4: {:?}", c_string);

    let ptr = c_string.into_raw();

    ptr as *mut c_char
}

#[no_mangle]
pub extern "C" fn new_v4_2(out: *mut c_char, size: usize) -> bool {
    let uuid_str = Uuid::new_v4().to_string();

    if uuid_str.len() + 1 > size {
        return false;
    }

    let c_string = match CString::new(uuid_str) {
        Ok(c_string) => c_string,
        Err(_) => return false,
    };

    // println!("uuid v4: {:?}", c_string);

    unsafe {
        std::ptr::copy_nonoverlapping(c_string.as_ptr(), out, c_string.to_bytes_with_nul().len());
    }

    true
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
