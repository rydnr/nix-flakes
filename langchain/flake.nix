{
  description = "A Flake that uses langchain as a dependency";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
    tenacity-flake.url =
      "github:rydnr/nix-flakes?dir=langchain/dependencies/tenacity-8.2.2";
    blis-flake.url =
      "github:rydnr/nix-flakes?dir=langchain/dependencies/blis-0.7.9";
    aiohttp-flake.url =
      "github:rydnr/nix-flakes?dir=langchain/dependencies/aiohttp-3.8.4";
    tiktoken-flake.url =
      "github:rydnr/nix-flakes?dir=langchain/dependencies/tiktoker-0.3.3";
  };

  outputs = { self, nixpkgs, flake-utils, tenacity-flake, blis-flake
    , aiohttp-flake, tiktoken-flake }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        tenacityOverlay = self: super: {
          python3Packages = super.python3Packages // {
            tenacity = tenacity-flake.packages.${system}.tenacity-8_2_2;
          };
        };

        blisOverlay = self: super: {
          python3Packages = super.python3Packages // {
            blis = blis-flake.packages.${system}.blis-0_7_9;
          };
        };

        aiohttpOverlay = self: super: {
          python3Packages = super.python3Packages // {
            aiohttp = aiohttp-flake.packages.${system}.aiohttp-3_8_4;
          };
        };

        tiktokenOverlay = self: super: {
          python3Packages = super.python3Packages // {
            tiktoken = tiktoken-flake.packages.${system}.tiktoken-0_3_3;
          };
        };

        pkgs = import nixpkgs {
          inherit system;
          overlays =
            [ tenacityOverlay blisOverlay aiohttpOverlay tiktokenOverlay ];
        };

        langchainPackage = let python = pkgs.python310;
        in python.pkgs.buildPythonPackage {

          pname = "langchain";
          version = "0.0.131";

          src = pkgs.fetchFromGitHub {
            owner = "hwchase17";
            repo = "langchain";
            rev = "v0.0.131";
            sha256 = "sha256-qBEU/SZO8HP68QFKcBJzfiC02F91YyN4ctp9A40CvWk=";
          };

          format = "pyproject";

          buildInputs = [ pkgs.poetry ];

          propagatedBuildInputs = let
            requiredDeps = with pkgs.python3Packages; [
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
            coredDeps = with pkgs.python3Packages; [
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
              utils = with pkgs.python3Packages; [
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

              apis = with pkgs.python3Packages; [
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
          meta = with pkgs.lib; {
            description =
              "Building applications with LLMs through composability";
            homepage = "https://langchain.readthedocs.io/en/latest/?";
            license = licenses.mit;
            maintainers = with maintainers; [ breakds ];
          };
        };
      in rec {
        packages.langchain = langchainPackage;
        packages.default = packages.langchain;

        devShell = pkgs.mkShell {
          buildInputs = with pkgs.python3Packages; [
            python
            jupyterlab
            numpy
            pandas
            matplotlib
            scipy
            importlib-metadata
            langchainPackage
          ];
        };
      });
}
