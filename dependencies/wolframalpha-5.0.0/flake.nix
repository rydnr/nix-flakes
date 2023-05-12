{
  description = "A Nix flake for wolframalpha 5.0.0 Python package";

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
          wolframalpha-5.0.0 = (import ./wolframalpha-5.0.0.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi
             inherit (pkgs) lib;
          };
          wolframalpha = packages.wolframalpha-5.0.0;
          default = packages.wolframalpha;
          meta = with lib; {
            description = ''
.. image:: https://img.shields.io/pypi/v/wolframalpha.svg
   :target: `PyPI link`_

.. image:: https://img.shields.io/pypi/pyversions/wolframalpha.svg
   :target: `PyPI link`_

.. _PyPI link: https://pypi.org/project/wolframalpha

.. image:: https://github.com/jaraco/wolframalpha/workflows/tests/badge.svg
   :target: https://github.com/jaraco/wolframalpha/actions?query=workflow%3A%22tests%22
   :alt: tests

.. image:: https://img.shields.io/badge/code%20style-black-000000.svg
   :target: https://github.com/psf/black
   :alt: Code style: Black

.. image:: https://readthedocs.org/projects/wolframalpha/badge/?version=latest
   :target: https://wolframalpha.readthedocs.io/en/latest/?badge=latest

Python Client built against the `Wolfram|Alpha <http://wolframalpha.com>`_
v2.0 API.

Usage
=====

See the self-documenting source in
`the docs <https://wolframalpha.readthedocs.io/en/latest/?badge=latest>`_
for examples to get started.



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
