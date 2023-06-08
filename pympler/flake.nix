{
  description =
    "Pympler is a development tool to measure, monitor and analyze the memory behavior of Python objects in a running Python application.";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
  };
  outputs = { self, ... }@inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixos { inherit system; };
        description =
          "Pympler is a development tool to measure, monitor and analyze the memory behavior of Python objects in a running Python application.";
        license = pkgs.lib.licenses.asl20;
        homepage = "https://github.com/pympler/pympler";
        maintainers = with pkgs.lib.maintainers; [ ];
        nixpkgsRelease = "nixos-23.05";
        shared = import ./shared.nix;
        pympler-1_0_1-for = python:
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
        packages = {
          pympler-1_0_1-python38 = pympler-1_0_1-for pkgs.python38;
          pympler-1_0_1-python39 = pympler-1_0_1-for pkgs.python39;
          pympler-1_0_1-python310 = pympler-1_0_1-for pkgs.python310;
          pympler-1_0_1-python311 = pympler-1_0_1-for pkgs.python311;
          pympler-latest-python38 = packages.pympler-1_0_1-python38;
          pympler-latest-python39 = packages.pympler-1_0_1-python39;
          pympler-latest-python310 = packages.pympler-1_0_1-python310;
          pympler-latest-python311 = packages.pympler-1_0_1-python311;
          pympler-latest = packages.pympler-latest-python311;
          default = packages.pympler-latest;
        };
        defaultPackage = packages.default;
        devShells = rec {
          pympler-1_0_1-python38 = shared.devShell-for {
            package = packages.pympler-1_0_1-python38;
            python = pkgs.python38;
            inherit pkgs nixpkgsRelease;
          };
          pympler-1_0_1-python39 = shared.devShell-for {
            package = packages.pympler-1_0_1-python39;
            python = pkgs.python39;
            inherit pkgs nixpkgsRelease;
          };
          pympler-1_0_1-python310 = shared.devShell-for {
            package = packages.pympler-1_0_1-python310;
            python = pkgs.python310;
            inherit pkgs nixpkgsRelease;
          };
          pympler-1_0_1-python311 = shared.devShell-for {
            package = packages.pympler-1_0_1-python311;
            python = pkgs.python311;
            inherit pkgs nixpkgsRelease;
          };
          pympler-latest-python38 = pympler-1_0_1-python38;
          pympler-latest-python39 = pympler-1_0_1-python39;
          pympler-latest-python310 = pympler-1_0_1-python310;
          pympler-latest-python311 = pympler-1_0_1-python311;
          pympler-latest = pympler-latest-python311;
          default = pympler-latest;
        };
      });
}
