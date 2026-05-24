//! Generating a random UUID.
//!
//! If you enable the `v4` feature you can generate random UUIDs.

fn main() {
    use uuid::Uuid;

    let id = Uuid::new_v4();

    assert_eq!(Some(uuid::Version::Random), id.get_version());

    println!("uuid v4: {}", id);

    // 将 UUID 转换为字符串
    let uuid_string = id.to_string();

    // 打印字符串形式的 UUID
    println!("UUID as string: {}", uuid_string);
}
