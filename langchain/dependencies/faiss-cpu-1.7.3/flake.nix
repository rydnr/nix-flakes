{
  description = "A Nix flake for faiss-cpu 1.7.3 Python package";

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
          faiss-cpu-1_7_3 = (import ./faiss-cpu-1.7.3.nix) {
            inherit (pythonPackages) buildPythonPackage fetchPypi setuptools;
            inherit (pkgs) lib;
            
            
            
            
            
            
          };
          faiss-cpu = packages.faiss-cpu-1_7_3;
          default = packages.faiss-cpu;
          meta = with lib; {
            description = ''

Faiss is a library for efficient similarity search and clustering of dense
vectors. It contains algorithms that search in sets of vectors of any size, up
to ones that possibly do not fit in RAM. It also contains supporting code for
evaluation and parameter tuning. Faiss is written in C++ with complete wrappers
for Python/numpy. It is developed by Facebook AI Research.

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
