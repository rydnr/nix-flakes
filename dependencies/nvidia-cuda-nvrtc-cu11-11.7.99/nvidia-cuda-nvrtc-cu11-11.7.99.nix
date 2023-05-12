{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "nvidia-cuda-nvrtc-cu11";
  version = "11.7.99";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9f1562822ea264b7e34ed5930567e89242d266448e936b85bc97a3370feabb03";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
NVRTC native runtime libraries

'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}
