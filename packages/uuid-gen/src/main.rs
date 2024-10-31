use std::path::Path;

use diplomat_tool::DocsUrlGenerator;

pub fn main() {
    //
    // real gen:
    //
    diplomat_tool::gen(
        Path::new("../uuid-ffi/core/src/lib.rs"),
        "mojo",
        Path::new("./build/abi"),
        &DocsUrlGenerator::default(),
        None,
        false,
    )
        .unwrap();


    //
    // temp gen: (for double check!)
    //
    diplomat_tool::gen(
        Path::new("../uuid-ffi/core/src/lib.rs"),
        "mojo",
        Path::new("../uuid-mojo/src/uuid_mojo/abi/"),
        &DocsUrlGenerator::default(),
        None,
        false,
    )
        .unwrap();
}
