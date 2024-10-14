from sys import ffi
from memory.unsafe_pointer import UnsafePointer
from sys import os_is_macos

fn version() -> String:
    print("uuid mojo: 0.1.2")
    return "0.1.2"

# os platform:
fn get_libname() -> StringLiteral:
    @parameter
    if os_is_macos():
        return "libuuid_ffi.dylib"
    else:
        return "libuuid_ffi.so"

# global use
# var h = ffi.DLHandle("dylib/libuuid_ffi.dylib")
var h = ffi.DLHandle(get_libname())


fn new_v4() -> UnsafePointer[UInt8]:
    var _fn_new_v4 = h.get_function[fn() -> UnsafePointer[UInt8]]("new_v4")

    var uuid = _fn_new_v4()
    print("mojo get uuid v4: ", uuid)
    return uuid


fn new_v4_2() -> Bool:
    _fn_new_v4_2 = h.get_function[fn(UnsafePointer[UInt8], UInt) -> Bool]("new_v4_2")

    var size = 128
    var out = UnsafePointer[UInt8].alloc(size)

    var ret = _fn_new_v4_2(out, size)
    print("mojo get uuid v4_2: ", out)
    return ret

fn new_v7()  -> UnsafePointer[UInt8]:
    _fn_new_v7 = h.get_function[fn() -> UnsafePointer[UInt8]]("new_v7")

    var uuid = _fn_new_v7()
    print("mojo get uuid v7: ", uuid)
    return uuid


