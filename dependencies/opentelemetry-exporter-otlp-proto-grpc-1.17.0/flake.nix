{
  description = "A Nix flake for opentelemetry-exporter-otlp-proto-grpc 1.17.0 Python package";

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
          opentelemetry-exporter-otlp-proto-grpc-1.17.0 = (import ./opentelemetry-exporter-otlp-proto-grpc-1.17.0.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi
             inherit (pkgs) lib;
          };
          opentelemetry-exporter-otlp-proto-grpc = packages.opentelemetry-exporter-otlp-proto-grpc-1.17.0;
          default = packages.opentelemetry-exporter-otlp-proto-grpc;
          meta = with lib; {
            description = ''
OpenTelemetry Collector Protobuf over gRPC Exporter
===================================================

|pypi|

.. |pypi| image:: https://badge.fury.io/py/opentelemetry-exporter-otlp-proto-grpc.svg
   :target: https://pypi.org/project/opentelemetry-exporter-otlp-proto-grpc/

This library allows to export data to the OpenTelemetry Collector using the OpenTelemetry Protocol using Protobuf over gRPC.

Installation
------------

::

     pip install opentelemetry-exporter-otlp-proto-grpc


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
