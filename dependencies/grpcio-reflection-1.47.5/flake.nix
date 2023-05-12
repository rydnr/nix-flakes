{
  description = "A Nix flake for grpcio-reflection 1.47.5 Python package";

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
          grpcio-reflection-1.47.5 = (import ./grpcio-reflection-1.47.5.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi
             inherit (pkgs) lib;
          };
          grpcio-reflection = packages.grpcio-reflection-1.47.5;
          default = packages.grpcio-reflection;
          meta = with lib; {
            description = ''
gRPC Python Reflection package
==============================

Reference package for reflection in GRPC Python.

Supported Python Versions
-------------------------
Python >= 3.7

Dependencies
------------

Depends on the `grpcio` package, available from PyPI via `pip install grpcio`.


'';
            license = licenses.mit;
            homepage = "None";
            maintainers = with maintainers; [ ];
          };
        };
        defaultPackage = packages.default;
        devShell = pkgs.mkShell {
          buildInputs = with pkgs.python3Packages; [ packages.default ];
        };
        shell = flake-utils.lib.mkShell {
          packages = system: [ self.packages.${system}.default ];
        };
      });
}
