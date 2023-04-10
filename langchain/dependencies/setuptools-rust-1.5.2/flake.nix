{
  description = "A Nix flake for setuptools-rust 1.5.2 Python package";

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
          setuptools-rust-1_5_2 = (import ./setuptools-rust-1.5.2.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi pythonOlder semantic-version
              typing-extensions;
            inherit (pkgs) lib;
          };
          setuptools-rust = packages.setuptools-rust-1_5_2;
          default = packages.setuptools-rust-1_5_2;
        };
        devShell = pkgs.mkShell {
          buildInputs = with pkgs.python3Packages; [ packages.default ];
        };
        shell = flake-utils.lib.mkShell {
          packages = system: [ self.packages.${system}.default ];
        };
      });
}
