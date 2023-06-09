{ buildPythonPackage, fetchPypi, jaraco_classes, lib, path, portend, setuptools
, setuptools-scm }:

buildPythonPackage rec {
  pname = "jaraco.services";
  version = "3.1.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-P854FzJWtUeUa0P78zinu3FOktA1XWx2hqL+9q11Zec=";
  };

  pythonNamespaces = [ "jaraco" ];

  nativeBuildInputs = [ setuptools setuptools-scm ];

  propagatedBuildInputs = [ jaraco_classes path portend ];

  meta = with lib; {
    description = "";
    license = licenses.mit;
    homepage = "https://github.com/jaraco/jaraco.services";
    maintainers = with maintainers; [ ];
  };
}
