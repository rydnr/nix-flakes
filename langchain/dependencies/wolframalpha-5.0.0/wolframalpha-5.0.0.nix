{ lib, stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "wolframalpha";
  version = "5.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "";
  };

  meta = with lib; {
    description = "Python Client built against the Wolfram|Alpha v2.0 API";
    license = licenses.mit;
    homepage = "https://github.com/jaraco/wolframalpha";
    maintainers = with maintainers; [ ];
  };
}
