{
  description = "A Nix flake for Tiktoken 0.3.3 Python package";

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
        packages.tiktoken-0_3_3 = (import ./tiktoken-0.3.3.nix) {
          inherit (pythonPackages)
            buildPythonPackage fetchPypi regex requests blobfile;
          inherit (pkgs) lib;
        };
        packages.default = packages.tiktoken-0_3_3;
      });
}
