{
  description = "A Nix flake for jupyter-events 0.6.3 Python package";

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
          jupyter-events-0.6.3 = (import ./jupyter-events-0.6.3.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi
             inherit (pkgs) lib;
          };
          jupyter-events = packages.jupyter-events-0.6.3;
          default = packages.jupyter-events;
          meta = with lib; {
            description = ''
# Jupyter Events

[![Build Status](https://github.com/jupyter/jupyter_events/actions/workflows/python-tests.yml/badge.svg?query=branch%3Amain++)](https://github.com/jupyter/jupyter_events/actions/workflows/python-tests.yml/badge.svg?query=branch%3Amain++)
[![codecov](https://codecov.io/gh/jupyter/jupyter_events/branch/main/graph/badge.svg?token=S9WiBg2iL0)](https://codecov.io/gh/jupyter/jupyter_events)
[![Documentation Status](https://readthedocs.org/projects/jupyter-events/badge/?version=latest)](http://jupyter-events.readthedocs.io/en/latest/?badge=latest)

_An event system for Jupyter Applications and extensions._

Jupyter Events enables Jupyter Python Applications (e.g. Jupyter Server, JupyterLab Server, JupyterHub, etc.) to emit **events**—structured data describing things happening inside the application. Other software (e.g. client applications like JupyterLab) can _listen_ and respond to these events.

## Install

Install Jupyter Events directly from PyPI:

```
pip install jupyter_events
```

or conda-forge:

```
conda install -c conda-forge jupyter_events
```

## Documentation

Documentation is available at [jupyter-events.readthedocs.io](https://jupyter-events.readthedocs.io).

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
