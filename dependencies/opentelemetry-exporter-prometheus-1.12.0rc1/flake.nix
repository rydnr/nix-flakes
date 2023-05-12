{
  description = "A Nix flake for opentelemetry-exporter-prometheus 1.12.0rc1 Python package";

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
          opentelemetry-exporter-prometheus-1.12.0rc1 = (import ./opentelemetry-exporter-prometheus-1.12.0rc1.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi
             inherit (pkgs) lib;
          };
          opentelemetry-exporter-prometheus = packages.opentelemetry-exporter-prometheus-1.12.0rc1;
          default = packages.opentelemetry-exporter-prometheus;
          meta = with lib; {
            description = ''
OpenTelemetry Prometheus Exporter
=================================

|pypi|

.. |pypi| image:: https://badge.fury.io/py/opentelemetry-exporter-prometheus.svg
   :target: https://pypi.org/project/opentelemetry-exporter-prometheus/

This library allows to export metrics data to `Prometheus <https://prometheus.io/>`_.

Installation
------------

::

     pip install opentelemetry-exporter-prometheus

References
----------

* `OpenTelemetry Prometheus Exporter <https://opentelemetry-python.readthedocs.io/en/latest/exporter/prometheus/prometheus.html>`_
* `Prometheus <https://prometheus.io/>`_
* `OpenTelemetry Project <https://opentelemetry.io/>`_

'';
            license = licenses.asl20;
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
