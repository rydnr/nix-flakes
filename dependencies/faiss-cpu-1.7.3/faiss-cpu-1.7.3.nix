{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "faiss-cpu";
  version = "1.7.3";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "343f025e0846239d987d0c719772387ad685b74e5ef62b2e5616cabef9062729";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''

Faiss is a library for efficient similarity search and clustering of dense
vectors. It contains algorithms that search in sets of vectors of any size, up
to ones that possibly do not fit in RAM. It also contains supporting code for
evaluation and parameter tuning. Faiss is written in C++ with complete wrappers
for Python/numpy. It is developed by Facebook AI Research.

'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}
