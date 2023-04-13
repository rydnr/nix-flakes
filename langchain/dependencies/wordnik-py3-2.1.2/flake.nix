{
  description = "A Nix flake for Wordnik-py3 2.1.2 Python package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
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
          wordnik-py3-2_1_2 = (import ./wordnik-py3-2.1.2.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi setuptools setuptools-scm;
            inherit (pkgs) lib;
          };
          wordnik-py3 = packages.wordnik-py3-2_1_2;
          default = packages.wordnik-py3;
          meta = with lib; {
            description =
              "This is a Python 3 client for the Wordnik.com v4 API. For more information, see http://developer.wordnik.com/";
            license = licenses.mit;
            homepage = "https://github.com/wordnik/wordnik-python3";
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
