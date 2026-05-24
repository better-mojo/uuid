"""UUID generation library for Mojo.

This library provides high-level UUID generation functions backed by a Rust FFI.

Example:
    ```mojo
    from uuid import uuid_v4, uuid_v7, gen_uuid_v4, gen_uuid_v7

    # Generate UUID v4 (random)
    var id4 = uuid_v4()
    print(id4)  # e.g., "550e8400-e29b-41d4-a716-446655440000"

    # Generate UUID v7 (time-ordered)
    var id7 = uuid_v7()
    print(id7)  # e.g., "018f3b3c-7e6b-7b3a-8b3a-3c7e6b7b3a8b"

    # Using pre-allocated buffer
    var id4_buf = gen_uuid_v4()
    print(id4_buf)

    var id7_buf = gen_uuid_v7()
    print(id7_buf)

    # Validate UUID
    if uuid_validate(id4):
        print("Valid UUID")

    # Get UUID version
    var version = uuid_version(id4)
    print("Version:", version)

    # Parse UUID to bytes
    var bytes = uuid_parse(id4)
    print("Bytes:", bytes)

    # Compare UUIDs
    var cmp = uuid_compare(id4, id7)
    print("Comparison:", cmp)
    ```
"""

from uuid.ffi import UuidFFI


# -----------------------------------------------------------------------
# UUID Generation
# -----------------------------------------------------------------------


def uuid_v4() raises -> String:
    """Generate a new UUID v4 (random) as a string.

    Returns:
        A new UUID v4 string in the format "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".
    """
    var ffi = UuidFFI()
    return ffi.uuid_v4()


def uuid_v7() raises -> String:
    """Generate a new UUID v7 (time-ordered) as a string.

    Returns:
        A new UUID v7 string in the format "xxxxxxxx-xxxx-7xxx-yxxx-xxxxxxxxxxxx".
    """
    var ffi = UuidFFI()
    return ffi.uuid_v7()


def gen_uuid_v4() raises -> String:
    """Generate a UUID v4 using a pre-allocated buffer.

    This is more efficient than uuid_v4() as it avoids some internal allocations.

    Returns:
        A new UUID v4 string.
    """
    comptime buf_size = 37  # 36 chars + null terminator

    var ffi = UuidFFI()

    # Use List as a buffer (same pattern as sqlite)
    var buf = List[UInt8](capacity=buf_size)
    buf.resize(buf_size, 0)

    # Call FFI function
    var size = ffi.gen_uuid_v4(buf.unsafe_ptr(), buf_size)

    # Convert to string from bytes (size includes null terminator, so use size - 1)
    var result = String()
    var actual_size = size - 1 if size > 0 else 0
    for i in range(actual_size):
        result += chr(Int(buf[i]))

    return result


def gen_uuid_v7() raises -> String:
    """Generate a UUID v7 using a pre-allocated buffer.

    Returns:
        A new UUID v7 string.
    """
    comptime buf_size = 37  # 36 chars + null terminator

    var ffi = UuidFFI()

    # Use List as a buffer (same pattern as sqlite)
    var buf = List[UInt8](capacity=buf_size)
    buf.resize(buf_size, 0)

    # Call FFI function
    var size = ffi.gen_uuid_v7(buf.unsafe_ptr(), buf_size)

    # Convert to string from bytes (size includes null terminator, so use size - 1)
    var result = String()
    var actual_size = size - 1 if size > 0 else 0
    for i in range(actual_size):
        result += chr(Int(buf[i]))

    return result


def gen_uuid_v4_batch(count: Int) raises -> List[String]:
    """Generate multiple UUID v4s efficiently.

    Args:
        count: Number of UUIDs to generate.

    Returns:
        List of UUID v4 strings.
    """
    comptime uuid_size = 37  # 36 chars + null terminator
    var buf_size = count * uuid_size

    var ffi = UuidFFI()

    # Allocate buffer for all UUIDs
    var buf = List[UInt8](capacity=buf_size)
    buf.resize(buf_size, 0)

    # Generate batch
    var generated = ffi.gen_uuid_v4_batch(buf.unsafe_ptr(), count, buf_size)

    # Extract UUIDs from buffer
    var results = List[String]()
    for i in range(generated):
        var offset = i * uuid_size
        var uuid_str = String()
        for j in range(36):  # 36 chars without null terminator
            uuid_str += chr(Int(buf[offset + j]))
        results.append(uuid_str)

    return results^


def gen_uuid_v7_batch(count: Int) raises -> List[String]:
    """Generate multiple UUID v7s efficiently.

    Args:
        count: Number of UUIDs to generate.

    Returns:
        List of UUID v7 strings.
    """
    comptime uuid_size = 37  # 36 chars + null terminator
    var buf_size = count * uuid_size

    var ffi = UuidFFI()

    # Allocate buffer for all UUIDs
    var buf = List[UInt8](capacity=buf_size)
    buf.resize(buf_size, 0)

    # Generate batch
    var generated = ffi.gen_uuid_v7_batch(buf.unsafe_ptr(), count, buf_size)

    # Extract UUIDs from buffer
    var results = List[String]()
    for i in range(generated):
        var offset = i * uuid_size
        var uuid_str = String()
        for j in range(36):  # 36 chars without null terminator
            uuid_str += chr(Int(buf[offset + j]))
        results.append(uuid_str)

    return results^


# -----------------------------------------------------------------------
# UUID Manipulation
# -----------------------------------------------------------------------


def uuid_parse(uuid_str: String) raises -> List[UInt8]:
    """Parse a UUID string into bytes.

    Args:
        uuid_str: UUID string to parse.

    Returns:
        List of 16 bytes representing the UUID, or empty list if invalid.
    """
    var ffi = UuidFFI()
    return ffi.uuid_parse(uuid_str)


def uuid_validate(uuid_str: String) raises -> Bool:
    """Validate if a string is a valid UUID.

    Args:
        uuid_str: String to validate.

    Returns:
        True if valid, False otherwise.
    """
    var ffi = UuidFFI()
    return ffi.uuid_validate(uuid_str)


def uuid_version(uuid_str: String) raises -> Int:
    """Get the version of a UUID.

    Args:
        uuid_str: UUID string.

    Returns:
        Version number (1-8), or -1 if invalid.
    """
    var ffi = UuidFFI()
    return ffi.uuid_version(uuid_str)


def uuid_compare(uuid1: String, uuid2: String) raises -> Int:
    """Compare two UUIDs.

    Args:
        uuid1: First UUID string.
        uuid2: Second UUID string.

    Returns:
        -1 if uuid1 < uuid2, 0 if equal, 1 if uuid1 > uuid2, -2 if error.
    """
    var ffi = UuidFFI()
    return ffi.uuid_compare(uuid1, uuid2)


def uuid_to_string(bytes: List[UInt8]) raises -> String:
    """Convert UUID bytes to string.

    Args:
        bytes: List of 16 bytes representing a UUID.

    Returns:
        UUID string, or "invalid_uuid" if bytes are invalid.
    """
    var ffi = UuidFFI()
    return ffi.uuid_to_string(bytes)
