{ buildPythonPackage, fetchPypi, lib, pmxbot, setuptools, setuptools-scm
, xmltodict }:

buildPythonPackage rec {
  pname = "wolframalpha";
  version = "5.0.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-OL8nZUA57IXMYsGZ3TGbak1qe63+168c0WHwga/bV8A=";
  };

  pythonNamespaces = [ "jaraco" ];

  nativeBuildInputs = [ setuptools setuptools-scm ];

  propagatedBuildInputs = [ xmltodict ];

  checkInputs = [ pmxbot ];

  meta = with lib; {
    description = "";
    license = licenses.mit;
    homepage = "https://github.com/jaraco/wolframalpha";
    maintainers = with maintainers; [ ];
  };
}
