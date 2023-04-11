#!/usr/bin/env python3
import os
from setuptools import setup
from setuptools_rust import Binding, RustExtension

# Replace the path_to_prebuilt_rust_extension with the actual path
path_to_prebuilt_rust_extension = "path/to/your/prebuilt/rust/extension"

rust_extension = RustExtension(
    "tiktoken._tiktoken",
    binding=Binding.PyO3,
    debug=False,
)

# Override the build method to use the prebuilt Rust extension
def build_fake_rust(self, *args, **kwargs):
    target_dir = self.get_ext_fullpath(self.target_fname)
    os.makedirs(os.path.dirname(target_dir), exist_ok=True)
    os.link(path_to_prebuilt_rust_extension, target_dir)

rust_extension.build = build_fake_rust

setup(
    name="tiktoken",
    rust_extensions=[rust_extension],
    package_data={"tiktoken": ["py.typed"]},
    packages=["tiktoken", "tiktoken_ext"],
    zip_safe=False,
)
