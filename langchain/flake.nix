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
  };

  outputs =
    { self, nixpkgs, flake-utils, tenacity-flake, blis-flake, aiohttp-flake }:
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

        pkgs = import nixpkgs {
          inherit system;
          overlays = [ tenacityOverlay blisOverlay aiohttpOverlay ];
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
              aiohttp
              pydantic
              sqlalchemy
              requests
              pyyaml
              numpy
              blis
            ];
            optionalDeps = with pkgs.python3Packages; [
              faiss
              redis
              #              spacy
              nltk
              beautifulsoup4
              pytorch
              jinja2
              google-api-python-client
              dataclasses-json
              tenacity
            ];
          in requiredDeps ++ optionalDeps;

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
