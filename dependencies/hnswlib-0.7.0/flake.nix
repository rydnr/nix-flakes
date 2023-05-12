{
  description = "A Nix flake for hnswlib 0.7.0 Python package";

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
          hnswlib-0.7.0 = (import ./hnswlib-0.7.0.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi
             inherit (pkgs) lib;
          };
          hnswlib = packages.hnswlib-0.7.0;
          default = packages.hnswlib;
          meta = with lib; {
            description = ''
hnsw

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
