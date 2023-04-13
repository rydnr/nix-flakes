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
            inherit (pythonPackages) buildPythonPackage fetchPypi;
            pythonPackages = pythonPackages;
            inherit (pkgs) lib poetry;
            tenacity = tenacity-flake.packages.${system}.tenacity;
            blis = blis-flake.packages.${system}.blis;
            aiohttp = aiohttp-flake.packages.${system}.aiohttp;
            tiktoken = tiktoken-flake.packages.${system}.tiktoken;
            wolframalpha = tiktoken-flake.packages.${system}.wolframalpha;
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
