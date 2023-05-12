{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "nvidia-cudnn-cu11";
  version = "8.5.0.96";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "402f40adfc6f418f9dae9ab402e773cfed9beae52333f6d86ae3107a1b9527e7";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
cuDNN runtime libraries containing primitives for deep neural networks.

'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}
