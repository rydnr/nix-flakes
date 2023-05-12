{
  description = "A Nix flake for opentelemetry-sdk 1.17.0 Python package";

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
          opentelemetry-sdk-1.17.0 = (import ./opentelemetry-sdk-1.17.0.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi
             inherit (pkgs) lib;
          };
          opentelemetry-sdk = packages.opentelemetry-sdk-1.17.0;
          default = packages.opentelemetry-sdk;
          meta = with lib; {
            description = ''
OpenTelemetry Python SDK
============================================================================

|pypi|

.. |pypi| image:: https://badge.fury.io/py/opentelemetry-sdk.svg
   :target: https://pypi.org/project/opentelemetry-sdk/

Installation
------------

::

    pip install opentelemetry-sdk

References
----------

* `OpenTelemetry Project <https://opentelemetry.io/>`_

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
