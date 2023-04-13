{
  description = "A Nix flake for wolframalpha 5.0.0 Python package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
    pmxbot-flake.url =
      "github:rydnr/nix-flakes?dir=langchain/dependencies/pmxbot-1122.14.2";
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
          wolframalpha-3_8_4 = (import ./wolframalpha-5.0.0.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi setuptools setuptools-scm xmltodict;
            inherit (pkgs) lib;
            pmxbot = pmxbot-flake.packages.${system}.pmxbot;
          };
          wolframalpha = packages.wolframalpha-3_8_4;
          default = packages.wolframalpha;
          meta = with lib; {
            description =
              "Python Client built against the Wolfram|Alpha v2.0 API";
            license = licenses.mit;
            homepage = "https://github.com/jaraco/wolframalpha";
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
