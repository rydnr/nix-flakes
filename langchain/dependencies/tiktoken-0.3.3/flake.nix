{
  description = "A Nix flake for Tiktoken 0.3.3 Python package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
    blobfile-flake.url =
      "github:rydnr/nix-flakes?dir=langchain/dependencies/blobfile-2.0.1";
  };

  outputs = { self, nixpkgs, flake-utils, blobfile-flake }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        blobfileOverlay = self: super: {
          python3Packages = super.python3Packages // {
            blobfile = blobfile-flake.packages.${system}.blobfile-2_0_1;
          };
        };
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ blobfileOverlay ];
        };
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
