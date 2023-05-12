{
  description = "A Nix flake for jupyter-server-terminals 0.4.4 Python package";

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
          jupyter-server-terminals-0.4.4 = (import ./jupyter-server-terminals-0.4.4.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi
             inherit (pkgs) lib;
          };
          jupyter-server-terminals = packages.jupyter-server-terminals-0.4.4;
          default = packages.jupyter-server-terminals;
          meta = with lib; {
            description = ''
# Jupyter Server Terminals

[![Build Status](https://github.com/jupyter-server/jupyter_server_terminals/actions/workflows/test.yml/badge.svg?query=branch%3Amain++)](https://github.com/jupyter-server/jupyter_server_terminals/actions?query=branch%3Amain++)
[![codecov](https://codecov.io/gh/jupyter-server/jupyter_server_terminals/branch/main/graph/badge.svg?token=6OPBSEMMUG)](https://codecov.io/gh/jupyter-server/jupyter_server_terminals)
[![Documentation Status](https://readthedocs.org/projects/jupyter-server-terminals/badge/?version=latest)](http://jupyter-server-terminals.readthedocs.io/en/latest/?badge=latest)

Jupyter Server Terminals is a Jupyter Server Extension providing support for terminals.

## Installation and Basic usage

To install the latest release locally, make sure you have
[pip installed](https://pip.readthedocs.io/en/stable/installing/) and run:

```
pip install jupyter_server_terminals
```

Jupyter Server Terminals currently supports Python>=3.6 on Linux, OSX and Windows.

### Testing

See [CONTRIBUTING](./CONTRIBUTING.rst#running-tests).

## Contributing

If you are interested in contributing to the project, see [CONTRIBUTING](./CONTRIBUTING.rst).

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
