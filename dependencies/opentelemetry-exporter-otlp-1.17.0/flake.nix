{
  description = "A Nix flake for opentelemetry-exporter-otlp 1.17.0 Python package";

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
          opentelemetry-exporter-otlp-1.17.0 = (import ./opentelemetry-exporter-otlp-1.17.0.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi
             inherit (pkgs) lib;
          };
          opentelemetry-exporter-otlp = packages.opentelemetry-exporter-otlp-1.17.0;
          default = packages.opentelemetry-exporter-otlp;
          meta = with lib; {
            description = ''
OpenTelemetry Collector Exporters
=================================

|pypi|

.. |pypi| image:: https://badge.fury.io/py/opentelemetry-exporter-otlp.svg
   :target: https://pypi.org/project/opentelemetry-exporter-otlp/

This library is provided as a convenience to install all supported OpenTelemetry Collector Exporters. Currently it installs:

* opentelemetry-exporter-otlp-proto-grpc
* opentelemetry-exporter-otlp-proto-http

In the future, additional packages will be available:
* opentelemetry-exporter-otlp-json-http

To avoid unnecessary dependencies, users should install the specific package once they've determined their
preferred serialization and protocol method.

Installation
------------

::

     pip install opentelemetry-exporter-otlp


References
----------

* `OpenTelemetry Collector Exporter <https://opentelemetry-python.readthedocs.io/en/latest/exporter/otlp/otlp.html>`_
* `OpenTelemetry Collector <https://github.com/open-telemetry/opentelemetry-collector/>`_
* `OpenTelemetry <https://opentelemetry.io/>`_
* `OpenTelemetry Protocol Specification <https://github.com/open-telemetry/oteps/blob/main/text/0035-opentelemetry-protocol.md>`_

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
