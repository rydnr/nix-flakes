{ buildPythonPackage, fetchPypi, jaraco_classes, jaraco_text, lib, setuptools
, setuptools-scm }:

buildPythonPackage rec {
  pname = "jaraco.ui";
  version = "2.3.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-r6ztbv2lyXFcF76XUGh8KD/5rOX7QtmhmXvttG9qiho=";
  };

  pythonNamespaces = [ "jaraco" ];

  nativeBuildInputs = [ setuptools setuptools-scm ];

  propagatedBuildInputs = [ jaraco_classes jaraco_text ];

  meta = with lib; {
    description = "";
    license = licenses.mit;
    homepage = "https://github.com/jaraco/jaraco.ui";
    maintainers = with maintainers; [ ];
  };
}
