{ aiohttp, blis, buildPythonPackage, fetchPypi, lib, openapi-schema-pydantic
, poetry, poetry2nix, python, pythonPackages, tenacity, tiktoken, wolframalpha
}:

buildPythonPackage rec {
  pname = "langchain";
  version = "0.0.138";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-RPPz0IGfzgVf2FlkDK/Yr4HMZJfa68JyHR/PMwJvvfY=";
  };

  nativeBuildInputs = [ poetry2nix ];

  buildInputs = [ poetry ];

  # Use poetry2nix's mkPoetryEnv to create a Python environment with the project's dependencies
  propagatedBuildInputs = (poetry2nix.mkPoetryEnv { py = python; }).inputs;

  pythonImportsCheck = [ "langchain" ];

  meta = with lib; {
    description = "Building applications with LLMs through composability";
    license = licenses.mit;
    homepage = "https://github.com/hwchase17/langchain";
    maintainers = with maintainers; [ ];
  };
}
