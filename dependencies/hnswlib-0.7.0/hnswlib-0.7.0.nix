{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "hnswlib";
  version = "0.7.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bc459668e7e44bb7454b256b90c98c5af750653919d9a91698dafcf416cf64c4";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
hnsw

'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}
