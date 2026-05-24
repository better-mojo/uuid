use uuid_ffi;

fn main() {
    #[cfg(feature = "headers")]
    uuid_ffi::generate_headers().expect("Failed to generate headers");


    uuid_ffi::ffi::generate().expect("Failed to generate headers");
}
