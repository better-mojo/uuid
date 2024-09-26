//! Generating a random UUID.
//!
//! If you enable the `v4` feature you can generate random UUIDs.

use uuid_ffi::ffi::new_v4;

fn main() {
    let uuid = new_v4();

    println!("uuid: {:?}", uuid);
}