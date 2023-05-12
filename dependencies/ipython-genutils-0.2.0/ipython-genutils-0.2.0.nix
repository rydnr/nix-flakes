{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "ipython-genutils";
  version = "0.2.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "72dd37233799e619666c9f639a9da83c34013a73e8bbc79a7a6348d93c61fab8";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
Pretend this doesn't exist. Nobody should use it.



'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}
