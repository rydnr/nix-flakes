{ buildPythonPackage, fetchPypi, lib, setuptools, setuptools-scm }:

buildPythonPackage rec {
  pname = "wordnik-py3";
  version = "2.1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5KVa6rnVRssLdq/WuFOmD5alVTVC+JwptPz2nbwjeos=";
  };

  nativeBuildInputs = [ setuptools setuptools-scm ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description =
      "This is a Python 3 client for the Wordnik.com v4 API. For more information, see http://developer.wordnik.com/";
    license = licenses.mit;
    homepage = "https://github.com/wordnik/wordnik-python3";
    maintainers = with maintainers; [ ];
  };
}
