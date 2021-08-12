package(default_visibility = ["//visibility:public"])

constraint_setting(
    name = "compiler",
)

constraint_value(
    name = "llvm",
    constraint_setting = ":compiler",
)

constraint_setting(
    name = "compiler_version",
)

constraint_value(
    name = "10",
    constraint_setting = ":compiler_version",
)

constraint_value(
    name = "11",
    constraint_setting = ":compiler_version",
)

constraint_value(
    name = "12",
    constraint_setting = ":compiler_version",
)

platform(
    name = "llvm_linux_x86_10",
    constraint_values = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
        ":llvm",
        ":10",
    ],
)

platform(
    name = "llvm_linux_x86_11",
    constraint_values = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
        ":llvm",
        ":11",
    ],
)

platform(
    name = "llvm_linux_x86_12",
    constraint_values = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
        ":llvm",
        ":12",
    ],
)
