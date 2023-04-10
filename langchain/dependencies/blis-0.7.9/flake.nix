{
  description = "A Nix flake for blis 0.7.9 Python package";

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
          blis-0_7_9 = (import ./blis-0.7.9.nix) {
            inherit (pythonPackages)
              buildPythonPackage cython fetchPypi hypothesis numpy pytest
              pythonOlder;
            inherit (pkgs) lib;
          };
          blis = packages.blis-0_7_9;
          default = packages.blis;
        };
        devShell = pkgs.mkShell {
          buildInputs = with pkgs.python3Packages; [ packages.default ];
        };
        shell = flake-utils.lib.mkShell {
          packages = system: [ self.packages.${system}.default ];
        };
      });
}
