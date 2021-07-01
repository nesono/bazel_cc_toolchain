load(
    "@bazel_tools//tools/build_defs/repo:utils.bzl",
    "workspace_and_buildfile",
)

_DOWNLOAD_SPEC = {
    "12.0.0": [
        "https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.0/clang+llvm-12.0.0-x86_64-linux-gnu-ubuntu-20.04.tar.xz",
        "a9ff205eb0b73ca7c86afc6432eed1c2d49133bd0d49e47b15be59bbf0dd292e",
        "clang+llvm-12.0.0-x86_64-linux-gnu-ubuntu-20.04",
    ],
    "11.1.0": [
        "https://github.com/llvm/llvm-project/releases/download/llvmorg-11.1.0/clang+llvm-11.1.0-x86_64-linux-gnu-ubuntu-20.10.tar.xz",
        "29b07422da4bcea271a88f302e5f84bd34380af137df18e33251b42dd20c26d7",
        "clang+llvm-11.1.0-x86_64-linux-gnu-ubuntu-20.10",
    ],
    "10.0.1": [
        "https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.1/clang+llvm-10.0.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz",
        "48b83ef827ac2c213d5b64f5ad7ed082c8bcb712b46644e0dc5045c6f462c231",
        "clang+llvm-10.0.1-x86_64-linux-gnu-ubuntu-16.04",
    ],
}

# implementation taken from http_archive
# (https://cs.opensource.google/bazel/bazel/+/master:tools/build_defs/repo/http.bzl)
def _download_and_extract(ctx):
    if ctx.attr.build_file and ctx.attr.build_file_content:
        fail("Only one of build_file and build_file_content can be provided.")

    download_info = ctx.download_and_extract(
        url = _DOWNLOAD_SPEC[ctx.attr.llvm_version][0],
        sha256 = _DOWNLOAD_SPEC[ctx.attr.llvm_version][1],
        stripPrefix = _DOWNLOAD_SPEC[ctx.attr.llvm_version][2],
    )

    workspace_and_buildfile(ctx)

    return

def _setup_llvm_impl(ctx):
    _download_and_extract(ctx)

    repo_path = str(ctx.path(""))
    relative_path = "external/{}".format(ctx.name)
    substitutions = {
        "%{toolchain_path}": relative_path,
        "%{toolchain_abspath}": repo_path,
        "%{llvm_version}": ctx.attr.llvm_version,
    }
    ctx.template(
        "cc_toolchain_config.bzl",
        Label("@cc_toolchain//:toolchain/cc_toolchain_config.bzl.tpl"),
        substitutions,
    )
    ctx.template(
        "BUILD.bazel",
        Label("@cc_toolchain//:toolchain/BUILD.tpl"),
        substitutions,
    )

setup_llvm = repository_rule(
    implementation = _setup_llvm_impl,
    attrs = {
        "netrc": attr.string(
            doc = "Location of the .netrc file to use for authentication",
        ),
        "llvm_version": attr.string(
            doc = "Version of LLVM to download",
        ),
        "build_file": attr.label(
            allow_single_file = True,
            doc =
                "The file to use as the BUILD file for this repository." +
                "This attribute is an absolute label (use '@//' for the main " +
                "repo). The file does not need to be named BUILD, but can " +
                "be (something like BUILD.new-repo-name may work well for " +
                "distinguishing it from the repository's actual BUILD files. " +
                "Either build_file or build_file_content can be specified, but " +
                "not both.",
        ),
        "build_file_content": attr.string(
            doc =
                "The content for the BUILD file for this repository. " +
                "Either build_file or build_file_content can be specified, but " +
                "not both.",
        ),
        "workspace_file": attr.label(
            doc =
                "The file to use as the `WORKSPACE` file for this repository. " +
                "Either `workspace_file` or `workspace_file_content` can be " +
                "specified, or neither, but not both.",
        ),
        "workspace_file_content": attr.string(
            doc =
                "The content for the WORKSPACE file for this repository. " +
                "Either `workspace_file` or `workspace_file_content` can be " +
                "specified, or neither, but not both.",
        ),
    },
)
