cc_library(
    name = "hello_lib",
    srcs = ["hello_lib.cc"],
    hdrs = ["hello_lib.h"],
)

cc_binary(
    name = "hello_with_lib_cc",
    srcs = ["hello_with_lib.cc"],
    deps = [":hello_lib"],
)

cc_binary(
    name = "hello_world_cc",
    srcs = ["hello_world.cc"],
)

cc_binary(
    name = "hello_world_c",
    srcs = ["hello_world.c"],
)

cc_test(
    name = "hello_test",
    srcs = ["hello_test.cc"],
    deps = [":hello_lib"],
)
