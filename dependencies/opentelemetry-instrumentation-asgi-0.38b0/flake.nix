{
  description = "A Nix flake for opentelemetry-instrumentation-asgi 0.38b0 Python package";

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
          opentelemetry-instrumentation-asgi-0.38b0 = (import ./opentelemetry-instrumentation-asgi-0.38b0.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi
             inherit (pkgs) lib;
          };
          opentelemetry-instrumentation-asgi = packages.opentelemetry-instrumentation-asgi-0.38b0;
          default = packages.opentelemetry-instrumentation-asgi;
          meta = with lib; {
            description = ''
OpenTelemetry ASGI Instrumentation
==================================

|pypi|

.. |pypi| image:: https://badge.fury.io/py/opentelemetry-instrumentation-asgi.svg
   :target: https://pypi.org/project/opentelemetry-instrumentation-asgi/


This library provides a ASGI middleware that can be used on any ASGI framework
(such as Django, Starlette, FastAPI or Quart) to track requests timing through OpenTelemetry.

Installation
------------

::

    pip install opentelemetry-instrumentation-asgi

References
----------

* `OpenTelemetry Project <https://opentelemetry.io/>`_
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
