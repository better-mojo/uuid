from sys import ffi


# global use
var h = ffi.DLHandle("dylib/libuuid.dylib")


def new_v4() -> String:
    _fn_new_v4 = h.get_function[fn() -> String]("new_v4")

    return _fn_new_v4()