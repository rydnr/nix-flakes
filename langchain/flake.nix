{
  description = "A Flake that uses langchain as a dependency";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/24.05";
    poetry2nix.url = "github:nix-community/poetry2nix";
    aiohttp-flake.url =
      "github:rydnr/nix-flakes?dir=langchain/dependencies/aiohttp-3.8.4";
    blis-flake.url =
      "github:rydnr/nix-flakes?dir=langchain/dependencies/blis-0.7.9";
    openapi-schema-pydantic-flake.url =
      "github:rydnr/nix-flakes?dir=langchain/dependencies/openapi-schema-pydantic-1.2.4";
    tenacity-flake.url =
      "github:rydnr/nix-flakes?dir=langchain/dependencies/tenacity-8.2.2";
    tiktoken-flake.url =
      "github:rydnr/nix-flakes?dir=langchain/dependencies/tiktoken-0.3.3";
    wolframalpha-flake.url =
      "github:rydnr/nix-flakes?dir=langchain/dependencies/wolframalpha-5.0.0";
  };

  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python3;
        pythonPackages = python.pkgs;
      in rec {
        packages = {
          langchain-0_0_138 = (import ./langchain-0.0.138.nix) {
            python = python;
            inherit (pkgs) lib poetry fetchFromGitHub;
            inherit (pythonPackages) setuptools;
            inherit (poetry2nix.legacyPackages.${system}) mkPoetryApplication;
            aiohttp = aiohttp-flake.packages.${system}.aiohttp;
            blis = blis-flake.packages.${system}.blis;
            openapi-schema-pydantic =
              openapi-schema-pydantic-flake.packages.${system}.openapi-schema-pydantic;
            tenacity = tenacity-flake.packages.${system}.tenacity;
            tiktoken = tiktoken-flake.packages.${system}.tiktoken;
            wolframalpha = wolframalpha-flake.packages.${system}.wolframalpha;
          };
          langchain = packages.langchain-0_0_138;
          default = packages.langchain;
          meta = with lib; {
            description =
              "Building applications with LLMs through composability";
            license = licenses.mit;
            homepage = "https://github.com/hwchase17/langchain";
            maintainers = with maintainers; [ ];
          };
        };
        devShell = pkgs.mkShell {
          buildInputs = with pkgs.python3Packages; [ packages.default ];
        };
        shell = flake-utils.lib.mkShell {
          packages = system: [ self.packages.${system}.default ];
        };
      });
}
