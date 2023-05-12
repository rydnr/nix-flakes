{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "types-pyopenssl";
  version = "23.1.0.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ac7fbc240930c2f9a1cbd2d04f9cb14ad0f15b0ad8d6528732a83747b1b2086e";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
## Typing stubs for pyOpenSSL

This is a PEP 561 type stub package for the `pyOpenSSL` package. It
can be used by type-checking tools like
[mypy](https://github.com/python/mypy/),
[pyright](https://github.com/microsoft/pyright),
[pytype](https://github.com/google/pytype/),
PyCharm, etc. to check code that uses
`pyOpenSSL`. The source for this package can be found at
https://github.com/python/typeshed/tree/main/stubs/pyOpenSSL. All fixes for
types and metadata should be contributed there.

See https://github.com/python/typeshed/blob/main/README.md for more details.
This package was generated from typeshed commit `be0ef211679fabf020dcc79cd4b5c43af0fa1839`.

'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}
