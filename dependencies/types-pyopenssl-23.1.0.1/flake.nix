{
  description = "A Nix flake for types-pyopenssl 23.1.0.1 Python package";

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
          types-pyopenssl-23.1.0.1 = (import ./types-pyopenssl-23.1.0.1.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi
             inherit (pkgs) lib;
          };
          types-pyopenssl = packages.types-pyopenssl-23.1.0.1;
          default = packages.types-pyopenssl;
          meta = with lib; {
            description = ''
## Typing stubs for pyOpenSSL

This is a PEP 561 type stub package for the `pyOpenSSL` package. It
can be used by type-checking tools like
[mypy](https://github.com/python/mypy/),
[pyright](https://github.com/microsoft/pyright),
[pytype](https://github.com/google/pytype/),
PyCharm, etc. to check code that uses
`pyOpenSSL`. The source for this package can be found at
https://github.com/python/typeshed/tree/main/stubs/pyOpenSSL. All fixes for
types and metadata should be contributed there.

See https://github.com/python/typeshed/blob/main/README.md for more details.
This package was generated from typeshed commit `be0ef211679fabf020dcc79cd4b5c43af0fa1839`.

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
