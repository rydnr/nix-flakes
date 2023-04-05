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
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python3;
        pythonPackages = python.pkgs;
      in rec {
        packages.tiktoken-0_3_3 = (import ./tiktoken-0.3.3.nix) {
          inherit (pythonPackages) buildPythonPackage fetchPypi regex requests;
          inherit (pkgs) lib;
          blobfile = blobfile-flake.packages.${system}.blobfile-2_0_1;
          urllib3 = pythonPackages.urllib3;
        };
        packages.default = packages.tiktoken-0_3_3;
        devShell = pkgs.mkShell {
          buildInputs = with pkgs.python3Packages; [ packages.tiktoken-0_3_3 ];
        };
      });
}
