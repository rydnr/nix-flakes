{
  description = "A Nix flake for opentelemetry-instrumentation-grpc 0.38b0 Python package";

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
          opentelemetry-instrumentation-grpc-0.38b0 = (import ./opentelemetry-instrumentation-grpc-0.38b0.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi
             inherit (pkgs) lib;
          };
          opentelemetry-instrumentation-grpc = packages.opentelemetry-instrumentation-grpc-0.38b0;
          default = packages.opentelemetry-instrumentation-grpc;
          meta = with lib; {
            description = ''
OpenTelemetry gRPC Integration
==============================

|pypi|

.. |pypi| image:: https://badge.fury.io/py/opentelemetry-instrumentation-grpc.svg
   :target: https://pypi.org/project/opentelemetry-instrumentation-grpc/

Client and server interceptors for `gRPC Python`_.

.. _gRPC Python: https://grpc.github.io/grpc/python/grpc.html

Installation
------------

::

     pip install opentelemetry-instrumentation-grpc


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
