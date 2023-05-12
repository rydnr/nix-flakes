{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "libclang";
  version = "16.0.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "65258a6bb3e7dc31dc9b26f8d42f53c9d3b959643ade291fcd1aef4855303ca6";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
libclang-for-pip
================

[![PyPI](https://img.shields.io/pypi/v/libclang)](https://pypi.org/project/libclang)
![Python](https://img.shields.io/pypi/pyversions/libclang)
![Downloads](https://img.shields.io/pypi/dw/libclang)
[![License](https://img.shields.io/pypi/l/libclang)](https://github.com/sighingnow/libclang/blob/master/LICENSE.TXT)

[![Arch: x86\_64](https://img.shields.io/badge/arch-x86__64-brightgreen)](https://pypi.org/project/libclang/#files)
[![Arch: aarch64](https://img.shields.io/badge/arch-aarch64-yellowgreen)](https://pypi.org/project/libclang/#files)
[![Arch: arm](https://img.shields.io/badge/arch-arm-orange)](https://pypi.org/project/libclang/#files)

[![Linux](https://github.com/sighingnow/libclang/workflows/libclang-linux-amd64/badge.svg)](https://github.com/sighingnow/libclang/actions/workflows/libclang-linux-amd64.yml)
[![Linux Arm](https://github.com/sighingnow/libclang/workflows/libclang-linux-arm/badge.svg)](https://github.com/sighingnow/libclang/actions/workflows/libclang-linux-arm.yml)
[![Linux AArch64](https://github.com/sighingnow/libclang/workflows/libclang-linux-aarch64/badge.svg)](https://github.com/sighingnow/libclang/actions/workflows/libclang-linux-aarch64.yml)
[![Linux Alpine](https://github.com/sighingnow/libclang/workflows/libclang-alpine-amd64/badge.svg)](https://github.com/sighingnow/libclang/actions/workflows/libclang-alpine-amd64.yml)

[![MacOS Intel](https://github.com/sighingnow/libclang/workflows/libclang-macosx-amd64/badge.svg)](https://github.com/sighingnow/libclang/actions/workflows/libclang-macosx-amd64.yml)
[![MacOS M1](https://img.shields.io/cirrus/github/sighingnow/libclang?label=libclang-macosx-arm64)](https://cirrus-ci.com/github/sighingnow/libclang)

[![Windows](https://github.com/sighingnow/libclang/workflows/libclang-windows-amd64/badge.svg)](https://github.com/sighingnow/libclang/actions/workflows/libclang-windows-amd64.yml)
[![Windows AArch64](https://github.com/sighingnow/libclang/workflows/libclang-windows-aarch64/badge.svg)](https://github.com/sighingnow/libclang/actions/workflows/libclang-windows-aarch64.yml)

The repository contains code taken from [the LLVM project][1], to make it easier to install
clang's python bindings.

The repository copies necessary Python binding files from LLVM repo, adds packaging scripts
to make it a valid Python package and finally uploads the package to [pypi][2]. To make the libclang
available without installing the LLVM toolkits, this package provides bundled static-linked libclang
shared library for different platforms, which, should work well on OSX, Windows, as well as
usual Linux distributions.

The aim of this project is to make the `clang.cindex` (aka., Clang Python Bindings)
available for more Python users, without setting up the LLVM environment. To install the package,
you just need to run

```bash
pip install libclang
```

Note that the library is named `libclang`, the package `clang` on PyPi is another package and
doesn't bundle the prebuilt shared library.

Internals
---------

Update class variable `library_path` of `Config` in `cindex.py` as:

```python
    library_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'native')
```

License
-------

This repository follows the license agreement of the LLVM project, see [Apache-2.0 WITH LLVM-exception](./LICENSE.TXT).

[1]: https://github.com/llvm/llvm-project/tree/main/clang/bindings/python
[2]: https://pypi.org/project/libclang

'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}
