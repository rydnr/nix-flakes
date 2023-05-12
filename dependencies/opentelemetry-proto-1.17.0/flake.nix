{
  description = "A Nix flake for opentelemetry-proto 1.17.0 Python package";

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
          opentelemetry-proto-1.17.0 = (import ./opentelemetry-proto-1.17.0.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi
             inherit (pkgs) lib;
          };
          opentelemetry-proto = packages.opentelemetry-proto-1.17.0;
          default = packages.opentelemetry-proto;
          meta = with lib; {
            description = ''
OpenTelemetry Python Proto
==========================

|pypi|

.. |pypi| image:: https://badge.fury.io/py/opentelemetry-proto.svg
   :target: https://pypi.org/project/opentelemetry-proto/

This library contains the generated code for OpenTelemetry protobuf data model. The code in the current
package was generated using the v0.17.0 release_ of opentelemetry-proto.

.. _release: https://github.com/open-telemetry/opentelemetry-proto/releases/tag/v0.17.0

Installation
------------

::

    pip install opentelemetry-proto

Code Generation
---------------

These files were generated automatically from code in opentelemetry-proto_.
To regenerate the code, run ``../scripts/proto_codegen.sh``.

To build against a new release or specific commit of opentelemetry-proto_,
update the ``PROTO_REPO_BRANCH_OR_COMMIT`` variable in
``../scripts/proto_codegen.sh``. Then run the script and commit the changes
as well as any fixes needed in the OTLP exporter.

.. _opentelemetry-proto: https://github.com/open-telemetry/opentelemetry-proto


References
----------

* `OpenTelemetry Project <https://opentelemetry.io/>`_
* `OpenTelemetry Proto <https://github.com/open-telemetry/opentelemetry-proto>`_
* `proto_codegen.sh script <https://github.com/open-telemetry/opentelemetry-python/blob/main/scripts/proto_codegen.sh>`_

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
