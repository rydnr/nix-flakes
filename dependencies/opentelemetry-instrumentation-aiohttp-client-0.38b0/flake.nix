{
  description = "A Nix flake for opentelemetry-instrumentation-aiohttp-client 0.38b0 Python package";

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
          opentelemetry-instrumentation-aiohttp-client-0.38b0 = (import ./opentelemetry-instrumentation-aiohttp-client-0.38b0.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi
             inherit (pkgs) lib;
          };
          opentelemetry-instrumentation-aiohttp-client = packages.opentelemetry-instrumentation-aiohttp-client-0.38b0;
          default = packages.opentelemetry-instrumentation-aiohttp-client;
          meta = with lib; {
            description = ''
OpenTelemetry aiohttp client Integration
========================================

|pypi|

.. |pypi| image:: https://badge.fury.io/py/opentelemetry-instrumentation-aiohttp-client.svg
   :target: https://pypi.org/project/opentelemetry-instrumentation-aiohttp-client/

This library allows tracing HTTP requests made by the
`aiohttp client <https://docs.aiohttp.org/en/stable/client.html>`_ library.

Installation
------------

::

     pip install opentelemetry-instrumentation-aiohttp-client

References
----------

* `OpenTelemetry Project <https://opentelemetry.io/>`_
* `aiohttp client Tracing <https://docs.aiohttp.org/en/stable/tracing_reference.html>`_
* `OpenTelemetry Python Examples <https://github.com/open-telemetry/opentelemetry-python/tree/main/docs/examples>`_

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
