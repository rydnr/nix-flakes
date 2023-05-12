{
  description = "A Nix flake for sphinx-typlog-theme 0.8.0 Python package";

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
          sphinx-typlog-theme-0.8.0 = (import ./sphinx-typlog-theme-0.8.0.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi
             inherit (pkgs) lib;
          };
          sphinx-typlog-theme = packages.sphinx-typlog-theme-0.8.0;
          default = packages.sphinx-typlog-theme;
          meta = with lib; {
            description = ''
Sphinx Typlog Theme
===================

A sphinx theme sponsored by Typlog_, created by `Hsiaoming Yang`_.

.. image:: https://badgen.net/badge/donate/lepture/ff69b4
   :target: https://lepture.com/donate
   :alt: Donate lepture
.. image:: https://badgen.net/badge//patreon/f96854?icon=patreon
   :target: https://patreon.com/lepture
   :alt: Become a patreon
.. image:: https://badgen.net/pypi/v/sphinx-typlog-theme
   :target: https://pypi.python.org/pypi/sphinx-typlog-theme/
   :alt: Latest Version
.. image:: https://img.shields.io/pypi/wheel/sphinx-typlog-theme.svg
   :target: https://pypi.python.org/pypi/sphinx-typlog-theme/
   :alt: Wheel Status

.. _Typlog: https://typlog.com/
.. _`Hsiaoming Yang`: https://lepture.com/

Examples
--------

Here are some examples which are using this theme:

- https://sphinx-typlog-theme.readthedocs.io/
- https://docs.authlib.org/
- https://webargs.readthedocs.io/



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
