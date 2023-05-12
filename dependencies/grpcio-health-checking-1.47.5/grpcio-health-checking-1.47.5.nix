{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "grpcio-health-checking";
  version = "1.47.5";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "659b83138cb2b7db71777044d0caf58bab4f958fce972900f8577ebb4edca29d";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
gRPC Python Health Checking
===========================

Reference package for GRPC Python health checking.

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
