//! Generating a random UUID.
//!
//! If you enable the `v4` feature you can generate random UUIDs.

use uuid_ffi::ffi::{new_v4, now_v7};


fn main() {
    let uuid = new_v4();

    println!("uuid v4: {:?}", uuid);

    let uuid_v7 = now_v7();
    println!("uuid v7: {:?}", uuid_v7);
}