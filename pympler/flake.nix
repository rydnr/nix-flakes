{
  description =
    "Pympler is a development tool to measure, monitor and analyze the memory behavior of Python objects in a running Python application.";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
  };
  outputs = { self, ... }@inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixos { inherit system; };
        python = pkgs.python3;
        pythonPackages = python.pkgs;
        description =
          "Pympler is a development tool to measure, monitor and analyze the memory behavior of Python objects in a running Python application.";
        license = pkgs.lib.licenses.asl20;
        homepage = "https://github.com/pympler/pympler";
        maintainers = with pkgs.lib.maintainers; [ ];
      in rec {
        packages = {
          pympler-1_0_1 = pythonPackages.buildPythonPackage rec {
            pname = "Pympler";
            version = "1.0.1";
            src = pythonPackages.fetchPypi {
              inherit pname version;
              sha256 = "sha256-mT8aNZnKP0/NcWDHVFrQYxDJ4S9wF0rnro1OJfbF0/o=";
            };

            doCheck = false;
            meta = with pkgs.lib; {
              inherit description license homepage maintainers;
            };
          };
          latest = packages.pympler-1_0_1;
          default = packages.latest;
          meta = with lib; {
            inherit description license homepage maintainers;
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
