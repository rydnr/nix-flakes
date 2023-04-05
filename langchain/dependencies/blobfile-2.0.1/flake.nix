{
  description = "A Nix flake for blobfile 2.0.1 Python package";

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
        packages.blobfile-2_0_1 = (import ./blobfile-2.0.1.nix) {
          inherit (pythonPackages) buildPythonPackage astor filelock urllib3;
          inherit (pkgs) lib fetchFromGitHub;
        };
        packages.default = packages.blobfile-2_0_1;
      });
}
