{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "nlpcloud";
  version = "1.0.40";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9efc67dadbf64015330035d8772aff144da3c24701ddef6173b1da3a1b31d407";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
NLP Cloud serves high performance pre-trained or custom models for NER, sentiment-analysis, classification, summarization, paraphrasing, grammar and spelling correction, keywords and keyphrases extraction, chatbot, product description and ad generation, intent classification, text generation, image generation, blog post generation, code generation, question answering, automatic speech recognition, machine translation, language detection, semantic search, semantic similarity, tokenization, POS tagging, embeddings, and dependency parsing. It is ready for production, served through a REST API.

This is the Python client for the API.

More details here: https://nlpcloud.io

Documentation: https://docs.nlpcloud.io

Github: https://github.com/nlpcloud/nlpcloud-python


'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}
