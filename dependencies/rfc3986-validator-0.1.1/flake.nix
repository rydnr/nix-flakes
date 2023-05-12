{
  description = "A Nix flake for rfc3986-validator 0.1.1 Python package";

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
          rfc3986-validator-0.1.1 = (import ./rfc3986-validator-0.1.1.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi
             inherit (pkgs) lib;
          };
          rfc3986-validator = packages.rfc3986-validator-0.1.1;
          default = packages.rfc3986-validator;
          meta = with lib; {
            description = ''
# rfc3986-validator

A pure python RFC3986 validator


[![image](https://img.shields.io/pypi/v/rfc3986_validator.svg)](https://pypi.python.org/pypi/rfc3986_validator)
[![Build Status](https://travis-ci.org/naimetti/rfc3986-validator.svg?branch=master)](https://travis-ci.org/naimetti/rfc3986-validator)

# Install

```shell script
pip install rfc3986-validator
```

# Usage

```pycon
>>> from rfc3986_validator import validate_rfc3986
>>> validate_rfc3986('http://foo.bar?q=Spaces should be encoded')
False

>>> validate_rfc3986('http://foo.com/blah_blah_(wikipedia)')
True
```

It also support validate [URI-reference](https://tools.ietf.org/html/rfc3986#page-49) rule 

```pycon
>>> validate_rfc3986('//foo.com/blah_blah', rule='URI_reference')
True
```

  - Free software: MIT license




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
