pub mod ffi;

#[cfg(feature = "headers")]
pub fn generate_headers() -> ::std::io::Result<()> {
    ::safer_ffi::headers::builder()
        .to_file("cffi.h")?
        .generate();

    ::safer_ffi::headers::builder()
        .to_file("cffi.h")?
        .generate()?;

    Ok(())
}
