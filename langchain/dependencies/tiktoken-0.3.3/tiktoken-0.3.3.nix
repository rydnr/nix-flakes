{ lib, buildPythonPackage, fetchPypi, regex, requests, blobfile }:

buildPythonPackage rec {
  pname = "tiktoken";
  version = "0.3.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "";
  };

  nativeBuildInputs = [ regex requests ];

  propagatedBuildInputs = [ blobfile ];

  meta = with lib; {
    description = "Fast BPE tokeniser for use with OpenAI's models.";
    homepage = "https://github.com/openai/tiktoken";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
