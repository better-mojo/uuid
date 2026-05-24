import uuid


def test_uuid() raises:
    # implement style 1:
    var id = uuid.uuid_v4()  # auto free memory
    var id2 = uuid.uuid_v7()  # auto free memory

    # implement style 2:
    var id3 = uuid.gen_uuid_v4()
    var id4 = uuid.gen_uuid_v7()  # auto free memory

    print(id)
    print(id2)

    print(id3)
    print(id4)


def main() raises:
    test_uuid()
