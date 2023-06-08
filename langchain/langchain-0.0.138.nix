{ aiohttp, blis, fetchFromGitHub, lib, openapi-schema-pydantic, poetry
, mkPoetryApplication, python, setuptools, tenacity, tiktoken, wolframalpha }:

let
  langchainPyProject = fetchFromGitHub {
    owner = "hwchase17";
    repo = "langchain";
    rev = "v0.0.138";
    sha256 = "sha256-0y3cymBXDLAv7o1j/ss1hPfBdoXY2NjTS5FEsRDHQmI=";
  };

  langchainSrc = mkPoetryApplication {
    projectDir = langchainPyProject;
    pname = "langchain";
    version = "0.0.138";
    pyModule = "langchain";
  };

  customPython = python.override {
    packageOverrides = self: super: {
      aiohttp = aiohttp;
      blis = blis;
      openapi-schema-pydantic = openapi-schema-pydantic;
      tenacity = tenacity;
      tiktoken = tiktoken;
      wolframalpha = wolframalpha;
    };
  };
in customPython.pkgs.buildPythonApplication rec {
  pname = "langchain";
  version = "0.0.138";
  format = "pyproject";

  src = langchainSrc;

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = with customPython.pkgs; [
    aiohttp
    blis
    openapi-schema-pydantic
    tenacity
    tiktoken
    wolframalpha
  ];

  pythonImportsCheck = [ "langchain" ];

  meta = with lib; {
    description = "Building applications with LLMs through composability";
    license = licenses.mit;
    homepage = "https://github.com/hwchase17/langchain";
    maintainers = with maintainers; [ ];
  };
}
