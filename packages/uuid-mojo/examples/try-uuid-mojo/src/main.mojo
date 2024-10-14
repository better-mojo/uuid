from uuid_mojo import new_v4, new_v7, new_v4_2, version
# from testing import assert_equal


fn main():
    var v = version()
    print(v)
    print(new_v4())
    print(new_v4_2())
#     print(new_v7())