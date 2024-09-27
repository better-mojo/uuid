from sys import ffi
from memory.unsafe_pointer import UnsafePointer


# global use
var h = ffi.DLHandle("dylib/libuuid_ffi.dylib")


def new_v4() -> UnsafePointer[UInt8]:
    var _fn_new_v4 = h.get_function[fn() -> UnsafePointer[UInt8]]("new_v4")

    var uuid = _fn_new_v4()
    print("mojo get uuid v4: ", uuid)
    return uuid


def new_v7()  -> UnsafePointer[UInt8]:
    _fn_new_v7 = h.get_function[fn() -> UnsafePointer[UInt8]]("new_v7")

    var uuid = _fn_new_v7()
    print("mojo get uuid v7: ", uuid)
    return uuid


