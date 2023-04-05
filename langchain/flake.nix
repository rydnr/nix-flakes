{
  description = "A Flake that uses langchain as a dependency";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
    tenacity-flake.url =
      "github:rydnr/nix-flakes?dir=langchain/dependencies/tenacity-8.2.2";
  };

  outputs = { self, nixpkgs, flake-utils, tenacity-flake }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        tenacityOverlay = self: super: {
          python3Packages = super.python3Packages // {
            tenacity = tenacity-flake.packages.${system}.tenacity-8_2_2;
          };
        };

        pkgs = import nixpkgs {
          inherit system;
          overlays = [ tenacityOverlay ];
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
              spacy
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
      in {
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
