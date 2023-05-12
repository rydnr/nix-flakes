{
  description = "A Nix flake for win32-setctime 1.1.0 Python package";

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
          win32-setctime-1.1.0 = (import ./win32-setctime-1.1.0.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi
             inherit (pkgs) lib;
          };
          win32-setctime = packages.win32-setctime-1.1.0;
          default = packages.win32-setctime;
          meta = with lib; {
            description = ''
# win32-setctime



[![Pypi version](https://img.shields.io/pypi/v/win32-setctime.svg)](https://pypi.python.org/pypi/win32-setctime) [![Python version](https://img.shields.io/badge/python-3.5%2B-blue.svg)](https://pypi.python.org/pypi/win32-setctime) [![Build status](https://img.shields.io/github/workflow/status/Delgan/win32-setctime/Tests/master)](https://github.com/Delgan/win32-setctime/actions/workflows/tests.yml?query=branch:master) [![License](https://img.shields.io/github/license/delgan/win32-setctime.svg)](https://github.com/Delgan/win32-setctime/blob/master/LICENSE)



A small Python utility to set file creation time on Windows.





## Installation



```shell

pip install win32-setctime

```



## Usage



```python

from win32_setctime import setctime



setctime("my_file.txt", 1561675987.509, follow_symlinks=True)

```




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
