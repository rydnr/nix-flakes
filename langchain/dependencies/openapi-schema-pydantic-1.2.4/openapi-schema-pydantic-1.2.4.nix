{ buildPythonPackage, fetchPypi, lib, pydantic, pytest, setuptools
, setuptools-scm }:

buildPythonPackage rec {
  pname = "openapi-schema-pydantic";
  version = "1.2.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-PiLPWLdKafdSzH5fFTf25EFkKC2ycAy7zTu5nd0GUZY=";
  };

  nativeBuildInputs = [ setuptools setuptools-scm ];

  propagatedBuildInputs = [ pydantic ];

  checkInputs = [ pytest ];

  meta = with lib; {
    description = "OpenAPI (v3) specification schema as Pydantic classes.";
    license = licenses.mit;
    homepage = "https://github.com/kuimono/openapi-schema-pydantic";
    maintainers = with maintainers; [ ];
  };
}
