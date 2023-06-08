{ buildPythonPackage, fetchPypi, lib, setuptools, swig4 }:

buildPythonPackage rec {
  pname = "faiss-cpu";
  version = "1.7.3";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-y3H+Pyk0cy0VfZ2M+27S3UAgoAZVcchIQv9qPwvqsxA=";
  };

  nativeBuildInputs = [ setuptools swig4 ];

  propagatedBuildInputs = [  ];

  buildInputs = [  ];

  meta = with lib; {
    description = ''
Faiss is a library for efficient similarity search and clustering of dense
vectors. It contains algorithms that search in sets of vectors of any size, up
to ones that possibly do not fit in RAM. It also contains supporting code for
evaluation and parameter tuning. Faiss is written in C++ with complete wrappers
for Python/numpy. It is developed by Facebook AI Research.
'';
    license = licenses.mit;
    homepage = "https://github.com/kyamagu/faiss-wheels";
    maintainers = with maintainers; [ ];
  };
}
