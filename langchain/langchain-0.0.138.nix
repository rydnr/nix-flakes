{ aiohttp, blis, buildPythonPackage, fetchPypi, lib, poetry, pythonPackages
, tenacity, tiktoken, wolframalpha }:

buildPythonPackage rec {
  pname = "langchain";
  version = "0.0.138";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "";
  };

  nativeBuildInputs = with python3Packages; [ setuptools setuptools-scm ];

  propagatedBuildInputs = [ ];

  format = "pyproject";

  buildInputs = [ pkgs.poetry ];

  propagatedBuildInputs = let
    requiredDeps = with pythonPackages; [
      absl-py
      aiodns
      pycares
      aiofiles
      aiosignal
      #              aiohttp-retry
      google-api-python-client

      aiohttp
      pydantic
      sqlalchemy
      requests
      pyyaml
      numpy
      blis
    ];
    coredDeps = with python3Packages; [
      pydantic
      sqlalchemy
      requests
      pyyaml
      numpy
      spacy
      nltk
      huggingface-hub
      transformers
      beautifulsoup4
      pytorch
      jinja2
      dataclasses-json
      tenacity
      aiohttp
    ];
    optionalDeps = {
      utils = with python3Packages; [
        faiss
        elasticsearch
        # opensearch-py
        redis
        # manifest-ml
        tiktoken
        # tensorflow-text
        # sentence-transformers
        # pypdf
        networkx
        # deeplake
        # pgvector
        psycopg2
        boto3
      ];

      apis = with python3Packages; [
        # wikipedia
        # pinecone-client
        # weaviate-client
        google-api-python-client
        # anthropic
        # qdrant-client
        wolframalpha
        # cohere
        openai
        # nlpcloud
        # google-search-results
        # aleph-alpha-client
        # jina
        pyowm # open street map
      ];
    };
  in coredDeps ++ optionalDeps.utils ++ optionalDeps.apis;
  #         in requiredDeps ++ optionalDeps;

  pythonImportsCheck = [ "langchain" ];

  meta = with lib; {
    description = "Building applications with LLMs through composability";
    license = licenses.mit;
    homepage = "https://github.com/hwchase17/langchain";
    maintainers = with maintainers; [ ];
  };
}
