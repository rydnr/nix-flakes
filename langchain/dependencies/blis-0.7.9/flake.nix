{
  description = "A Nix flake for blis 0.7.9 Python package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python3;
        pythonPackages = python.pkgs;
      in rec {
        packages.blis-0_7_9 = (import ./blis-0.7.9.nix) {
          inherit (pythonPackages)
            buildPythonPackage cython fetchPypi hypothesis numpy pytest
            pythonOlder;
          inherit (pkgs) lib;
        };
        packages.default = packages.blis-0_7_9;
      });
}
