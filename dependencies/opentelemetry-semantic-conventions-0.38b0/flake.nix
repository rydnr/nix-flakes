{
  description = "A Nix flake for opentelemetry-semantic-conventions 0.38b0 Python package";

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
          opentelemetry-semantic-conventions-0.38b0 = (import ./opentelemetry-semantic-conventions-0.38b0.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi
             inherit (pkgs) lib;
          };
          opentelemetry-semantic-conventions = packages.opentelemetry-semantic-conventions-0.38b0;
          default = packages.opentelemetry-semantic-conventions;
          meta = with lib; {
            description = ''
OpenTelemetry Semantic Conventions
==================================

|pypi|

.. |pypi| image:: https://badge.fury.io/py/opentelemetry-semantic-conventions.svg
   :target: https://pypi.org/project/opentelemetry-semantic-conventions/

This library contains generated code for the semantic conventions defined by the OpenTelemetry specification.

Installation
------------

::

    pip install opentelemetry-semantic-conventions

Code Generation
---------------

These files were generated automatically from code in semconv_.
To regenerate the code, run ``../scripts/semconv/generate.sh``.

To build against a new release or specific commit of opentelemetry-specification_,
update the ``SPEC_VERSION`` variable in
``../scripts/semconv/generate.sh``. Then run the script and commit the changes.

.. _opentelemetry-specification: https://github.com/open-telemetry/opentelemetry-specification
.. _semconv: https://github.com/open-telemetry/opentelemetry-python/tree/main/scripts/semconv


References
----------

* `OpenTelemetry Project <https://opentelemetry.io/>`_
* `OpenTelemetry Semantic Conventions YAML Definitions <https://github.com/open-telemetry/opentelemetry-specification/tree/main/semantic_conventions>`_
* `generate.sh script <https://github.com/open-telemetry/opentelemetry-python/blob/main/scripts/semconv/generate.sh>`_

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
