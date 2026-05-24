"""Unit tests for uuid library.

Tests cover:
- UUID v4 generation (random UUIDs)
- UUID v7 generation (time-ordered UUIDs)
- UUID format validation
- UUID uniqueness
- Buffer-based generation
"""

from std.testing import assert_equal, assert_true, assert_false
import uuid


# -----------------------------------------------------------------------
# Helper functions
# -----------------------------------------------------------------------


def _is_valid_uuid_format(s: String) -> Bool:
    """Check if string matches UUID format: xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx (v4)
    or xxxxxxxx-xxxx-7xxx-yxxx-xxxxxxxxxxxx (v7).
    """
    if s.byte_length() != 36:
        return False

    # Convert to bytes for indexing
    var bytes = s.as_bytes()

    # Check dashes at positions 8, 13, 18, 23
    if (
        bytes[8] != 45 or bytes[13] != 45 or bytes[18] != 45 or bytes[23] != 45
    ):  # 45 is '-'
        return False

    # Check all other characters are hex digits
    for i in range(36):
        if i == 8 or i == 13 or i == 18 or i == 23:
            continue
        var c = bytes[i]
        # Check if c is a hex digit (0-9, a-f, A-F)
        var is_hex = (
            (c >= 48 and c <= 57)
            or (c >= 97 and c <= 102)
            or (c >= 65 and c <= 70)
        )
        if not is_hex:
            return False

    return True


def _get_version(s: String) -> Int:
    """Get UUID version from string (character at position 14)."""
    if s.byte_length() < 15:
        return -1
    var bytes = s.as_bytes()
    var version_char = bytes[14]
    if version_char == 52:  # '4'
        return 4
    elif version_char == 55:  # '7'
        return 7
    return -1


def _get_char_at(s: String, pos: Int) -> Int:
    """Get byte value at position in string."""
    return Int(s.as_bytes()[pos])


# -----------------------------------------------------------------------
# UUID v4 tests
# -----------------------------------------------------------------------


def test_uuid_v4_format() raises:
    """Generated UUID v4 has correct format."""
    var id = uuid.uuid_v4()
    assert_true(_is_valid_uuid_format(id), "UUID v4 format is invalid")
    assert_equal(_get_version(id), 4, "UUID v4 should have version 4")


def test_uuid_v4_length() raises:
    """Generated UUID v4 has correct length (36 characters)."""
    var id = uuid.uuid_v4()
    assert_equal(id.byte_length(), 36, "UUID v4 length should be 36")


def test_uuid_v4_uniqueness() raises:
    """Generated UUID v4s are unique."""
    var ids = List[String]()
    for _ in range(100):
        ids.append(uuid.uuid_v4())

    # Check all are unique
    for i in range(len(ids)):
        for j in range(i + 1, len(ids)):
            assert_false(ids[i] == ids[j], "UUID v4 collision detected")


def test_uuid_v4_variant_bits() raises:
    """UUID v4 has correct variant bits (8, 9, a, or b at position 19)."""
    for _ in range(10):
        var id = uuid.uuid_v4()
        var variant_byte = _get_char_at(id, 19)
        # 56='8', 57='9', 97='a', 98='b'
        var valid_variant = (
            variant_byte == 56
            or variant_byte == 57
            or variant_byte == 97
            or variant_byte == 98
        )
        assert_true(valid_variant, "UUID v4 variant bits invalid")


# -----------------------------------------------------------------------
# UUID v7 tests
# -----------------------------------------------------------------------


def test_uuid_v7_format() raises:
    """Generated UUID v7 has correct format."""
    var id = uuid.uuid_v7()
    assert_true(_is_valid_uuid_format(id), "UUID v7 format is invalid")
    assert_equal(_get_version(id), 7, "UUID v7 should have version 7")


def test_uuid_v7_length() raises:
    """Generated UUID v7 has correct length (36 characters)."""
    var id = uuid.uuid_v7()
    assert_equal(id.byte_length(), 36, "UUID v7 length should be 36")


def test_uuid_v7_uniqueness() raises:
    """Generated UUID v7s are unique."""
    var ids = List[String]()
    for _ in range(100):
        ids.append(uuid.uuid_v7())

    # Check all are unique
    for i in range(len(ids)):
        for j in range(i + 1, len(ids)):
            assert_false(ids[i] == ids[j], "UUID v7 collision detected")


def test_uuid_v7_time_ordering() raises:
    """UUID v7s are time-ordered (monotonically increasing)."""
    var ids = List[String]()
    for _ in range(10):
        ids.append(uuid.uuid_v7())

    # Check ordering (UUID v7 strings should be lexicographically ordered by time)
    for i in range(len(ids) - 1):
        assert_true(ids[i] < ids[i + 1], "UUID v7 should be time-ordered")


# -----------------------------------------------------------------------
# Buffer-based generation tests
# -----------------------------------------------------------------------


def test_gen_uuid_v4_format() raises:
    """Buffer-based UUID v4 has correct format."""
    var id = uuid.gen_uuid_v4()
    assert_true(_is_valid_uuid_format(id), "gen_uuid_v4 format is invalid")
    assert_equal(_get_version(id), 4, "gen_uuid_v4 should have version 4")


def test_gen_uuid_v4_length() raises:
    """Buffer-based UUID v4 has correct length."""
    var id = uuid.gen_uuid_v4()
    assert_equal(id.byte_length(), 36, "gen_uuid_v4 length should be 36")


def test_gen_uuid_v7_format() raises:
    """Buffer-based UUID v7 has correct format."""
    var id = uuid.gen_uuid_v7()
    assert_true(_is_valid_uuid_format(id), "gen_uuid_v7 format is invalid")
    assert_equal(_get_version(id), 7, "gen_uuid_v7 should have version 7")


def test_gen_uuid_v7_length() raises:
    """Buffer-based UUID v7 has correct length."""
    var id = uuid.gen_uuid_v7()
    assert_equal(id.byte_length(), 36, "gen_uuid_v7 length should be 36")


def test_gen_uuid_v4_v7_consistency() raises:
    """Buffer-based and direct generation produce same format."""
    var direct_v4 = uuid.uuid_v4()
    var buffer_v4 = uuid.gen_uuid_v4()
    var direct_v7 = uuid.uuid_v7()
    var buffer_v7 = uuid.gen_uuid_v7()

    # Both should have same format (version bits differ)
    assert_equal(_get_version(direct_v4), 4)
    assert_equal(_get_version(buffer_v4), 4)
    assert_equal(_get_version(direct_v7), 7)
    assert_equal(_get_version(buffer_v7), 7)


# -----------------------------------------------------------------------
# Main test runner
# -----------------------------------------------------------------------


def main() raises:
    """Run all UUID tests."""
    print("Running UUID library tests...")

    # UUID v4 tests
    print("\n=== UUID v4 Tests ===")
    test_uuid_v4_format()
    print("✓ test_uuid_v4_format passed")

    test_uuid_v4_length()
    print("✓ test_uuid_v4_length passed")

    test_uuid_v4_uniqueness()
    print("✓ test_uuid_v4_uniqueness passed")

    test_uuid_v4_variant_bits()
    print("✓ test_uuid_v4_variant_bits passed")

    # UUID v7 tests
    print("\n=== UUID v7 Tests ===")
    test_uuid_v7_format()
    print("✓ test_uuid_v7_format passed")

    test_uuid_v7_length()
    print("✓ test_uuid_v7_length passed")

    test_uuid_v7_uniqueness()
    print("✓ test_uuid_v7_uniqueness passed")

    test_uuid_v7_time_ordering()
    print("✓ test_uuid_v7_time_ordering passed")

    # Buffer-based tests
    print("\n=== Buffer-based Generation Tests ===")
    test_gen_uuid_v4_format()
    print("✓ test_gen_uuid_v4_format passed")

    test_gen_uuid_v4_length()
    print("✓ test_gen_uuid_v4_length passed")

    test_gen_uuid_v7_format()
    print("✓ test_gen_uuid_v7_format passed")

    test_gen_uuid_v7_length()
    print("✓ test_gen_uuid_v7_length passed")

    test_gen_uuid_v4_v7_consistency()
    print("✓ test_gen_uuid_v4_v7_consistency passed")

    print("\n=== All tests passed! ===")
