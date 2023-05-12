{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "nvidia-cuda-runtime-cu11";
  version = "11.7.99";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cc768314ae58d2641f07eac350f40f99dcb35719c4faff4bc458a7cd2b119e31";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
CUDA Runtime native Libraries

'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}
