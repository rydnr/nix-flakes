{
  description = "A Nix flake for tensorflow-macos 2.11.0 Python package";

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
          tensorflow-macos-2.11.0 = (import ./tensorflow-macos-2.11.0.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi
             inherit (pkgs) lib;
          };
          tensorflow-macos = packages.tensorflow-macos-2.11.0;
          default = packages.tensorflow-macos;
          meta = with lib; {
            description = ''
[![Python](https://img.shields.io/pypi/pyversions/tensorflow.svg?style=plastic)](https://badge.fury.io/py/tensorflow)
[![PyPI](https://badge.fury.io/py/tensorflow.svg)](https://badge.fury.io/py/tensorflow)

TensorFlow is an open source software library for high performance numerical
computation. Its flexible architecture allows easy deployment of computation
across a variety of platforms (CPUs, GPUs, TPUs), and from desktops to clusters
of servers to mobile and edge devices.

Originally developed by researchers and engineers from the Google Brain team
within Google's AI organization, it comes with strong support for machine
learning and deep learning and the flexible numerical computation core is used
across many other scientific domains. TensorFlow is licensed under [Apache
2.0](https://github.com/tensorflow/tensorflow/blob/master/LICENSE).

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
