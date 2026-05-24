"""Test UUID library."""

from uuid import uuid_v4, uuid_v7, gen_uuid_v4, gen_uuid_v7


def main() raises:
    print("Testing UUID library...")

    # Test uuid_v4
    print("\n=== Testing uuid_v4() ===")
    for i in range(3):
        var id = uuid_v4()
        print("UUID v4:", id)

    # Test uuid_v7
    print("\n=== Testing uuid_v7() ===")
    for i in range(3):
        var id = uuid_v7()
        print("UUID v7:", id)

    # Test gen_uuid_v4
    print("\n=== Testing gen_uuid_v4() ===")
    for i in range(3):
        var id = gen_uuid_v4()
        print("UUID v4 (buffer):", id)

    # Test gen_uuid_v7
    print("\n=== Testing gen_uuid_v7() ===")
    for i in range(3):
        var id = gen_uuid_v7()
        print("UUID v7 (buffer):", id)

    print("\n=== All tests passed! ===")
