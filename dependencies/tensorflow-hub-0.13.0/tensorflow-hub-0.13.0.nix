{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "tensorflow-hub";
  version = "0.13.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3544f4fd9fd99e4eeb6da1b5b5320e4a2dbdef7f9bb778f66f76d6790f32dd65";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''

'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}
