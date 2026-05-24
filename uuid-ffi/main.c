#include <stdlib.h>
#include <stdio.h>
#include "cffi.h"

int main(int argc, char const *const argv[])
{
    // 使用 rs_uuid_v4 和 rs_uuid_v7
    char *uuid_v4 = rs_uuid_v4();
    char *uuid_v7 = rs_uuid_v7();

    printf("uuid v4: %s\n", uuid_v4);
    printf("uuid v7: %s\n", uuid_v7);

    // 释放内存
    free_rs_string(uuid_v4);
    free_rs_string(uuid_v7);

    // 使用 rs_gen_uuid_v4 和 rs_gen_uuid_v7
    char buffer_v4[37]; // UUID 字符串长度为 36 字符 + 1 个空字符
    char buffer_v7[37];

    size_t len_v4 = rs_gen_uuid_v4((uint8_t *)buffer_v4, sizeof(buffer_v4));
    size_t len_v7 = rs_gen_uuid_v7((uint8_t *)buffer_v7, sizeof(buffer_v7));

    // 确保字符串以空字符结尾
    buffer_v4[sizeof(buffer_v4) - 1] = '\0';
    buffer_v7[sizeof(buffer_v7) - 1] = '\0';

    printf("generated uuid v4: %s (length: %zu)\n", buffer_v4, len_v4);
    printf("generated uuid v7: %s (length: %zu)\n", buffer_v7, len_v7);

    return EXIT_SUCCESS;
}