package(default_visibility = ["//visibility:public"])
load("@llvm_toolchain//:cc_toolchain_config.bzl", "cc_toolchain_config")

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
        "bin/llvm-ar",
        "bin/clang",
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
    all_files = "@llvm_toolchain//:all_files",
    compiler_files = "@llvm_toolchain//:compiler_files",
    dwp_files = ":empty",
    linker_files = "@llvm_toolchain//:linker_files",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 0,
    toolchain_config = ":llvm_config",
    toolchain_identifier = "llvm",
)
