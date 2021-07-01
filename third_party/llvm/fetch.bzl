load("@cc_toolchain//:third_party/llvm/setup.bzl", "setup_llvm")

# TODO: Add version as parameter
def load_and_setup_llvm(llvm_version = "12.0.0"):
    setup_llvm(
        name = "llvm_toolchain_" + llvm_version,
        llvm_version = llvm_version,
        build_file = "@//:toolchain/BUILD",
    )
