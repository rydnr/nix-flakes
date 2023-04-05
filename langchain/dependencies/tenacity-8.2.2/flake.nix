{
  description = "A Nix flake for tenacity 8.2.2 Python package";

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
        packages.tenacity-8_2_2 = (import ./tenacity-8.2.2.nix) {
          inherit (pythonPackages)
            buildPythonPackage fetchPypi isPy27 isPy3k pbr pytest six futures
            monotonic typing setuptools-scm sphinx tornado typeguard;
          inherit (pkgs) lib;
        };
        packages.default = packages.tenacity-8_2_2;
      });
}
