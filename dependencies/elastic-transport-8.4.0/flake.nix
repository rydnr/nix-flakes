{
  description = "A Nix flake for elastic-transport 8.4.0 Python package";

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
          elastic-transport-8.4.0 = (import ./elastic-transport-8.4.0.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi
             inherit (pkgs) lib;
          };
          elastic-transport = packages.elastic-transport-8.4.0;
          default = packages.elastic-transport;
          meta = with lib; {
            description = ''
# elastic-transport-python

[![PyPI](https://img.shields.io/pypi/v/elastic-transport)](https://pypi.org/elastic-transport)
[![Python Versions](https://img.shields.io/pypi/pyversions/elastic-transport)](https://pypi.org/elastic-transport)
[![PyPI Downloads](https://pepy.tech/badge/elastic-transport)](https://pepy.tech/project/elastic-transport)
[![CI Status](https://img.shields.io/github/workflow/status/elastic/elastic-transport-python/CI/main)](https://github.com/elastic/elastic-transport-python/actions)

Transport classes and utilities shared among Python Elastic client libraries

This library was lifted from [`elasticsearch-py`](https://github.com/elastic/elasticsearch-py)
and then transformed to be used across all Elastic services
rather than only Elasticsearch.

### Installing from PyPI

```
$ python -m pip install elastic-transport
```

Versioning follows the major and minor version of the Elastic Stack version and
the patch number is incremented for bug fixes within a minor release.                      |

## Documentation

Documentation including an API reference is available on [Read the Docs](https://elastic-transport-python.readthedocs.io).

## License

`elastic-transport-python` is available under the Apache-2.0 license.
For more details see [LICENSE](https://github.com/elastic/elastic-transport-python/blob/main/LICENSE).

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
