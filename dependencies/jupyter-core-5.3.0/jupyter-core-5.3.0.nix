{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "jupyter-core";
  version = "5.3.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d4201af84559bc8c70cead287e1ab94aeef3c512848dde077b7684b54d67730d";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
There is no reason to install this package on its own.
'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}
