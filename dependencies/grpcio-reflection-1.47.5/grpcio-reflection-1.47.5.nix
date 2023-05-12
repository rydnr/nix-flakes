{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "grpcio-reflection";
  version = "1.47.5";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8cfd222f2116b7e1bcd55bd2a1fcb168c5a9cd20310151d6278563f516e8ae1e";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
gRPC Python Reflection package
==============================

Reference package for reflection in GRPC Python.

Supported Python Versions
-------------------------
Python >= 3.7

Dependencies
------------

Depends on the `grpcio` package, available from PyPI via `pip install grpcio`.


'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}
