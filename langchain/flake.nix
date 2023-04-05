{
  description = "A Flake that uses langchain as a dependency";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
    poetry2nix.url = "github:nix-community/poetry2nix";
  };

  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python3;
        pythonPackages = python.pkgs;
        langchain-src = pkgs.fetchFromGitHub {
          owner = "hwchase17";
          repo = "langchain";
          rev = "v0.0.131";
          sha256 = "sha256-qBEU/SZO8HP68QFKcBJzfiC02F91YyN4ctp9A40CvWk=";
        };
      in rec {
        packages.langchain =
          pkgs.poetry2nix.mkPoetryApplication { projectDir = langchain-src; };
        packages.default = packages.langchain;

        devShells = pkgs.mkShellNoCC {
          packages = [
            (pkgs.${system}.poetry2nix.mkPoetryApplication {
              projectDir = langchain-src;
            })
            pkgs.poetry
          ];
        };
      });
}
