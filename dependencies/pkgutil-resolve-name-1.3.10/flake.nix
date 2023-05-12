{
  description = "A Nix flake for pkgutil-resolve-name 1.3.10 Python package";

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
          pkgutil-resolve-name-1.3.10 = (import ./pkgutil-resolve-name-1.3.10.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi
             inherit (pkgs) lib;
          };
          pkgutil-resolve-name = packages.pkgutil-resolve-name-1.3.10;
          default = packages.pkgutil-resolve-name;
          meta = with lib; {
            description = ''
pkgutil-resolve-name
====================

A backport of Python 3.9's ``pkgutil.resolve_name``.
See the `Python 3.9 documentation <https://docs.python.org/3.9/library/pkgutil.html#pkgutil.resolve_name>`__.

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
