workspace(name = "cc_toolchain")

load("@//:third_party/llvm/fetch.bzl", "load_and_setup_llvm")

# FYI 10.0.1 is failing on arch - while loading the binary
load_and_setup_llvm(llvm_version = "10.0.1")

load_and_setup_llvm(llvm_version = "11.1.0")

load_and_setup_llvm(llvm_version = "12.0.0")
