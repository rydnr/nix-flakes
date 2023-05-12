{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "tensorflow-text";
  version = "2.11.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c9d4797e331da37419f2b19159fbc0f125ed60467340e9a209ab8f8d65856704";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
TF.Text is a TensorFlow library of text related ops, modules, and subgraphs. The
library can perform the preprocessing regularly required by text-based models,
and includes other features useful for sequence modeling not provided by core
TensorFlow.

See the README on GitHub for further documentation.
http://github.com/tensorflow/text



'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}
