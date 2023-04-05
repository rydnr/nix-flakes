{ lib, buildPythonPackage, fetchPypi, regex, requests, blobfile }:

buildPythonPackage rec {
  pname = "tiktoken";
  version = "0.3.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-l7WLe/2pRXkeyFXlPRZujsIMY3iUK5OFGmyRnd+dBJY=";
  };

  nativeBuildInputs = [ regex requests blobfile ];

  meta = with lib; {
    description = "Fast BPE tokeniser for use with OpenAI's models.";
    homepage = "https://github.com/openai/tiktoken";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
