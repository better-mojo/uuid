"""Test new UUID API features."""

import uuid


def main() raises:
    print("=== Testing New UUID API ===\n")

    # Test basic generation
    print("1. Basic UUID Generation:")
    var id4 = uuid.uuid_v4()
    var id7 = uuid.uuid_v7()
    print("  UUID v4:", id4)
    print("  UUID v7:", id7)

    # Test validation
    print("\n2. UUID Validation:")
    print("  Is v4 valid?", uuid.uuid_validate(id4))
    print("  Is v7 valid?", uuid.uuid_validate(id7))
    print("  Is 'invalid' valid?", uuid.uuid_validate("invalid"))

    # Test version detection
    print("\n3. UUID Version Detection:")
    print("  v4 version:", uuid.uuid_version(id4))
    print("  v7 version:", uuid.uuid_version(id7))

    # Test parsing
    print("\n4. UUID Parsing:")
    var bytes4 = uuid.uuid_parse(id4)
    print("  v4 bytes count:", len(bytes4))
    var bytes7 = uuid.uuid_parse(id7)
    print("  v7 bytes count:", len(bytes7))

    # Test bytes to string
    print("\n5. Bytes to String:")
    if len(bytes4) == 16:
        var reconstructed = uuid.uuid_to_string(bytes4)
        print("  Reconstructed v4:", reconstructed)
        print("  Match original?", reconstructed == id4)

    # Test comparison
    print("\n6. UUID Comparison:")
    var cmp = uuid.uuid_compare(id4, id7)
    print("  v4 vs v7:", cmp)
    var cmp_same = uuid.uuid_compare(id4, id4)
    print("  v4 vs v4:", cmp_same)

    # Note: Batch generation requires new Rust library build
    # print("\n7. Batch Generation (v4):")
    # var batch4 = uuid.gen_uuid_v4_batch(5)
    # for i in range(len(batch4)):
    #     print("  UUID", i, ":", batch4[i])

    print("\n=== All tests completed! ===")
