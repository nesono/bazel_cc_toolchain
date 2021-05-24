load(
    "@bazel_tools//tools/build_defs/repo:utils.bzl",
    "workspace_and_buildfile",
)

_URL_BASE_TEMPLATE = "https://github.com/llvm/llvm-project/releases/download/llvmorg-{0}/clang+llvm-{0}-x86_64-linux-gnu-ubuntu-20.04.tar.xz"
_STRIP_PREFIX_TEMPLATE = "clang+llvm-{0}-x86_64-linux-gnu-ubuntu-20.04"
_SHA256 = {"12.0.0": "a9ff205eb0b73ca7c86afc6432eed1c2d49133bd0d49e47b15be59bbf0dd292e"}

# implementation taken from http_archive
# (https://cs.opensource.google/bazel/bazel/+/master:tools/build_defs/repo/http.bzl)
def _download_and_extract(ctx):
    if ctx.attr.build_file and ctx.attr.build_file_content:
        fail("Only one of build_file and build_file_content can be provided.")

    url = _URL_BASE_TEMPLATE.format(ctx.attr.llvm_version)
    strip_prefix = _STRIP_PREFIX_TEMPLATE.format(ctx.attr.llvm_version)

    download_info = ctx.download_and_extract(
        url,
        sha256 = _SHA256[ctx.attr.llvm_version],
        stripPrefix = strip_prefix,
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
