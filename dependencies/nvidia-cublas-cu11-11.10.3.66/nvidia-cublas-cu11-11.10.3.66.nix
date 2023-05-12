{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "nvidia-cublas-cu11";
  version = "11.10.3.66";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d32e4d75f94ddfb93ea0a5dda08389bcc65d8916a25cb9f37ac89edaeed3bded";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
CUBLAS native runtime libraries

'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}
