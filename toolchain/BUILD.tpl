package(default_visibility = ["//visibility:public"])

load("@llvm_toolchain_%{llvm_version}//:cc_toolchain_config.bzl", "cc_toolchain_config")

filegroup(
    name = "all_files",
    srcs = glob(["**"]),
)

filegroup(
    name = "compiler_files",
    srcs = [
        "bin/clang",
        "bin/clang++",
        "bin/clang-cpp",
    ],
)

filegroup(
    name = "linker_files",
    srcs = [
        "bin/clang",
        "bin/llvm-ar",
    ],
)

cc_toolchain_config(name = "llvm_config")

cc_toolchain_suite(
    name = "llvm_suite",
    toolchains = {
        "k8": ":llvm",
    },
)

filegroup(name = "empty")

cc_toolchain(
    name = "llvm",
    all_files = "@llvm_toolchain_%{llvm_version}//:all_files",
    compiler_files = "@llvm_toolchain_%{llvm_version}//:compiler_files",
    dwp_files = ":empty",
    linker_files = "@llvm_toolchain_%{llvm_version}//:linker_files",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 0,
    toolchain_config = ":llvm_config",
    toolchain_identifier = "llvm",
)

platform(
    name = "linux_x86",
    constraint_values = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
)

toolchain_type(
    name = "linux_x86_toolchain_type",
    compatible_with = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
)

toolchain(
    name = "llvm_toolchain",
    exec_compatible_with = [":linux_x86"],
    target_compatible_with = [":linux_x86"],
    toolchain = ":llvm",
    toolchain_type = ":linux_x86_toolchain_type",
)
