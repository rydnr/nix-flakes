{
  description = "A Nix flake for clickhouse-connect 0.5.20 Python package";

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
          clickhouse-connect-0.5.20 = (import ./clickhouse-connect-0.5.20.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi
             inherit (pkgs) lib;
          };
          clickhouse-connect = packages.clickhouse-connect-0.5.20;
          default = packages.clickhouse-connect;
          meta = with lib; {
            description = ''
## ClickHouse Connect

A suite of Python packages for connecting Python to ClickHouse:
* Pandas DataFrames
* Numpy Arrays
* PyArrow Tables
* SQLAlchemy 1.3 and 1.4 (limited feature set)
* Apache Superset 1.4+


### Complete Documentation
The documentation for ClickHouse Connect has moved to
[ClickHouse Docs](https://clickhouse.com/docs/en/integrations/language-clients/python/intro) 


### Installation

```
pip install clickhouse-connect
```

ClickHouse Connect requires Python 3.7 or higher.  

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
