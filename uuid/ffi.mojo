"""Low-level FFI wrappers for the UUID library.

All handles are stored as Int (pointer address). Input C strings are passed
as Int via unsafe_ptr() -> Int cast. Output C-string return values are received
as UnsafePointer[UInt8, MutExternalOrigin] and immediately copied into owned
String values via StringSlice.

The library is loaded at runtime via OwnedDLHandle so Mojo's JIT never needs
to resolve symbols at compile time.

Do not call UuidFFI methods from user code -- use the high-level API in __init__.mojo.
"""

from std.ffi import OwnedDLHandle, RTLD
from std.os import getenv
from std.sys.info import CompilationTarget
from std.memory import UnsafePointer


# -----------------------------------------------------------------------
# Internal helpers
# -----------------------------------------------------------------------


def _ptr_to_string(p: UnsafePointer[UInt8, MutExternalOrigin]) -> String:
    """Copy a C string at p into an owned Mojo String.

    Args:
        p: Pointer to a null-terminated UTF-8 string returned by the library.
           Null pointer returns an empty string.

    Returns:
        Owned String copy, or empty string for null pointers.
    """
    # Note: UnsafePointer is non-null by design in modern Mojo
    # We assume the FFI returns a valid pointer or we handle it at the call site
    return String(StringSlice(unsafe_from_utf8_ptr=p))


def _find_uuid_library() -> String:
    """Locate libuuid_ffi via $CONDA_PREFIX (pixi) or bare soname.

    Search order:
    1. $CONDA_PREFIX/lib/libuuid_ffi.so (Linux) or
       $CONDA_PREFIX/lib/libuuid_ffi.dylib (macOS) when set.
    2. Bare soname, relying on LD_LIBRARY_PATH / dyld path.

    Returns:
        Library path string for OwnedDLHandle.
    """
    var prefix = getenv("CONDA_PREFIX", "")
    if prefix:
        comptime if CompilationTarget.is_linux():
            return prefix + "/lib/libuuid_ffi.so"
        else:
            return prefix + "/lib/libuuid_ffi.dylib"
    comptime if CompilationTarget.is_linux():
        return "libuuid_ffi.so"
    else:
        return "libuuid_ffi.dylib"


# -----------------------------------------------------------------------
# UuidFFI
# -----------------------------------------------------------------------


struct UuidFFI(Movable):
    """Runtime-loaded UUID FFI: dlopen + dlsym for all C entry-points.

    Loads libuuid_ffi at construction via OwnedDLHandle and resolves
    every function pointer via get_function. All opaque pointer arguments
    are represented as Int (64-bit on all supported platforms), matching
    the C ABI on x86-64 and arm64.

    The OS reference-counts the underlying shared library, so multiple
    concurrent OwnedDLHandle objects map to a single loaded image.
    RTLD.NODELETE ensures dlclose is a no-op: the library stays
    resident for the process lifetime.
    """

    var _lib: OwnedDLHandle

    # -- UUID generation functions ------------------------------------------
    var _fn_rs_uuid_v4: def() thin abi("C") -> UnsafePointer[
        UInt8, MutExternalOrigin
    ]
    var _fn_rs_uuid_v7: def() thin abi("C") -> UnsafePointer[
        UInt8, MutExternalOrigin
    ]
    var _fn_free_rs_string: def(
        UnsafePointer[UInt8, MutExternalOrigin]
    ) thin abi("C") -> None
    var _fn_rs_gen_uuid_v4: def(Int, Int) thin abi("C") -> Int
    var _fn_rs_gen_uuid_v7: def(Int, Int) thin abi("C") -> Int

    def __init__(out self, lib_path: String = "") raises:
        """Load libuuid_ffi and resolve all function pointers.

        Args:
            lib_path: Explicit path to the library. If empty,
                      _find_uuid_library() is used (honours $CONDA_PREFIX).

        Raises:
            Error: If the library cannot be opened or a symbol is missing.
        """
        var path = lib_path if lib_path else _find_uuid_library()
        # RTLD.NODELETE: dlclose() becomes a no-op for this handle.
        self._lib = OwnedDLHandle(path, RTLD.NOW | RTLD.GLOBAL | RTLD.NODELETE)

        # UUID generation (core functions)
        self._fn_rs_uuid_v4 = self._lib.get_function[
            def() thin abi("C") -> UnsafePointer[UInt8, MutExternalOrigin]
        ]("rs_uuid_v4")
        self._fn_rs_uuid_v7 = self._lib.get_function[
            def() thin abi("C") -> UnsafePointer[UInt8, MutExternalOrigin]
        ]("rs_uuid_v7")
        self._fn_free_rs_string = self._lib.get_function[
            def(UnsafePointer[UInt8, MutExternalOrigin]) thin abi("C") -> None
        ]("free_rs_string")
        self._fn_rs_gen_uuid_v4 = self._lib.get_function[
            def(Int, Int) thin abi("C") -> Int
        ]("rs_gen_uuid_v4")
        self._fn_rs_gen_uuid_v7 = self._lib.get_function[
            def(Int, Int) thin abi("C") -> Int
        ]("rs_gen_uuid_v7")

    # -- UUID generation ----------------------------------------------------

    def uuid_v4(self) -> String:
        """Generate a new UUID v4 as a string.

        Returns:
            A new UUID v4 string (36 characters).
        """
        var raw = self._fn_rs_uuid_v4()
        var result = _ptr_to_string(raw)
        self._fn_free_rs_string(raw)
        return result

    def uuid_v7(self) -> String:
        """Generate a new UUID v7 as a string.

        Returns:
            A new UUID v7 string (36 characters).
        """
        var raw = self._fn_rs_uuid_v7()
        var result = _ptr_to_string(raw)
        self._fn_free_rs_string(raw)
        return result

    def gen_uuid_v4(self, buf: UnsafePointer[UInt8, _], size: Int) -> Int:
        """Generate a UUID v4 into a pre-allocated buffer.

        Args:
            buf: Pointer to the buffer to write the UUID string into.
            size: Size of the buffer (should be at least 37 bytes).

        Returns:
            Number of bytes written, or 0 if buffer is too small.
        """
        return self._fn_rs_gen_uuid_v4(Int(buf), size)

    def gen_uuid_v7(self, buf: UnsafePointer[UInt8, _], size: Int) -> Int:
        """Generate a UUID v7 into a pre-allocated buffer.

        Args:
            buf: Pointer to the buffer to write the UUID string into.
            size: Size of the buffer (should be at least 37 bytes).

        Returns:
            Number of bytes written, or 0 if buffer is too small.
        """
        return self._fn_rs_gen_uuid_v7(Int(buf), size)

    def gen_uuid_v4_batch(
        self, buf: UnsafePointer[UInt8, _], count: Int, buf_size: Int
    ) -> Int:
        """Generate multiple UUID v4s into a pre-allocated buffer.

        Args:
            buf: Pointer to the buffer to write UUID strings into.
            count: Number of UUIDs to generate.
            buf_size: Total size of the buffer (should be at least count * 37).

        Returns:
            Number of UUIDs generated, or 0 if buffer is too small.
        """
        var batch_fn = self._lib.get_function[
            def(Int, Int, Int) thin abi("C") -> Int
        ]("rs_gen_uuid_v4_batch")
        return batch_fn(Int(buf), count, buf_size)

    def gen_uuid_v7_batch(
        self, buf: UnsafePointer[UInt8, _], count: Int, buf_size: Int
    ) -> Int:
        """Generate multiple UUID v7s into a pre-allocated buffer.

        Args:
            buf: Pointer to the buffer to write UUID strings into.
            count: Number of UUIDs to generate.
            buf_size: Total size of the buffer (should be at least count * 37).

        Returns:
            Number of UUIDs generated, or 0 if buffer is too small.
        """
        var batch_fn = self._lib.get_function[
            def(Int, Int, Int) thin abi("C") -> Int
        ]("rs_gen_uuid_v7_batch")
        return batch_fn(Int(buf), count, buf_size)

    # -- UUID manipulation --------------------------------------------------

    def uuid_parse(self, uuid_str: String) -> List[UInt8]:
        """Parse a UUID string into bytes.

        Args:
            uuid_str: UUID string to parse.

        Returns:
            List of 16 bytes representing the UUID, or empty list if invalid.
        """
        var result = List[UInt8](capacity=16)
        result.resize(16, 0)
        var str_bytes = uuid_str.as_bytes()

        var parse_fn = self._lib.get_function[
            def(Int, Int) thin abi("C") -> Int32
        ]("uuid_parse")
        var ret = parse_fn(
            Int(str_bytes.unsafe_ptr()), Int(result.unsafe_ptr())
        )

        if ret != 0:
            result.clear()
        return result^

    def uuid_validate(self, uuid_str: String) -> Bool:
        """Validate if a string is a valid UUID.

        Args:
            uuid_str: String to validate.

        Returns:
            True if valid, False otherwise.
        """
        var str_bytes = uuid_str.as_bytes()
        var validate_fn = self._lib.get_function[
            def(Int) thin abi("C") -> Int32
        ]("uuid_validate")
        return validate_fn(Int(str_bytes.unsafe_ptr())) == 1

    def uuid_version(self, uuid_str: String) -> Int:
        """Get the version of a UUID.

        Args:
            uuid_str: UUID string.

        Returns:
            Version number (1-8), or -1 if invalid.
        """
        var str_bytes = uuid_str.as_bytes()
        var version_fn = self._lib.get_function[
            def(Int) thin abi("C") -> Int32
        ]("uuid_version")
        var version = version_fn(Int(str_bytes.unsafe_ptr()))
        return Int(version)

    def uuid_compare(self, uuid1: String, uuid2: String) -> Int:
        """Compare two UUIDs.

        Args:
            uuid1: First UUID string.
            uuid2: Second UUID string.

        Returns:
            -1 if uuid1 < uuid2, 0 if equal, 1 if uuid1 > uuid2, -2 if error.
        """
        var bytes1 = uuid1.as_bytes()
        var bytes2 = uuid2.as_bytes()
        var compare_fn = self._lib.get_function[
            def(Int, Int) thin abi("C") -> Int32
        ]("uuid_compare")
        var result = compare_fn(
            Int(bytes1.unsafe_ptr()), Int(bytes2.unsafe_ptr())
        )
        return Int(result)

    def uuid_to_string(self, bytes: List[UInt8]) -> String:
        """Convert UUID bytes to string.

        Args:
            bytes: List of 16 bytes representing a UUID.

        Returns:
            UUID string, or "invalid_uuid" if bytes are invalid.
        """
        if len(bytes) < 16:
            return "invalid_uuid"

        var to_str_fn = self._lib.get_function[
            def(Int) thin abi("C") -> UnsafePointer[UInt8, MutExternalOrigin]
        ]("uuid_to_string")
        var raw = to_str_fn(Int(bytes.unsafe_ptr()))
        var result = _ptr_to_string(raw)
        self._fn_free_rs_string(raw)
        return result
