{
  description =
    "Nix flake for pympler";

  inputs = rec {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    nixpkgs.url = "github:NixOS/nixpkgs/24.05";
  };
  outputs = { self, ... }@inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        description =
          "Pympler is a development tool to measure, monitor and analyze the memory behavior of Python objects in a running Python application.";
        license = pkgs.lib.licenses.asl20;
        homepage = "https://github.com/pympler/pympler";
        maintainers = with pkgs.lib.maintainers; [ ];
        nixpkgsRelease = "nixpkgs-23.05";
        shared = import ../shared.nix;
        pympler-for = python:
          python.pkgs.buildPythonPackage rec {
            pname = "Pympler";
            version = "1.0.1";
            src = python.pkgs.fetchPypi {
              inherit pname version;
              sha256 = "sha256-mT8aNZnKP0/NcWDHVFrQYxDJ4S9wF0rnro1OJfbF0/o=";
            };

            doCheck = false;
            meta = with lib; {
              inherit description license homepage maintainers;
            };
          };
      in rec {
        defaultPackage = packages.default-python312;
        devShells = rec {
          default = pympler-python312;
          pympler-python39 = shared.devShell-for {
            package = packages.pympler-python39;
            python = pkgs.python39;
            inherit pkgs nixpkgsRelease;
          };
          pympler-python310 = shared.devShell-for {
            package = packages.pympler-python310;
            python = pkgs.python310;
            inherit pkgs nixpkgsRelease;
          };
          pympler-python311 = shared.devShell-for {
            package = packages.pympler-python311;
            python = pkgs.python311;
            inherit pkgs nixpkgsRelease;
          };
          pympler-python312 = shared.devShell-for {
            package = packages.pympler-python312;
            python = pkgs.python312;
            inherit pkgs nixpkgsRelease;
          };
          pympler-python313 = shared.devShell-for {
            package = packages.pympler-python313;
            python = pkgs.python313;
            inherit pkgs nixpkgsRelease;
          };
        };
        packages = {
          default = packages.pympler-python312;
          pympler-python39 = pympler-for pkgs.python39;
          pympler-python310 = pympler-for pkgs.python310;
          pympler-python311 = pympler-for pkgs.python311;
          pympler-python312 = pympler-for pkgs.python312;
          pympler-python313 = pympler-for pkgs.python313;
        };
      });
}
