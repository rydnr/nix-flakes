{
  description = "Python gRPC Client for EventStoreDBs";

  inputs = rec {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    nixpkgs.url = "github:NixOS/nixpkgs/24.05";
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        description = "Python gRPC Client for EventStoreDB";
        license = pkgs.lib.licenses.bsd3;
        homepage = "https://github.com/pyeventsourcing/esdbclient";
        maintainers = with pkgs.lib.maintainers; [ ];
        shared = import ../shared.nix;
        esdbclient-for = python:
          python.pkgs.buildPythonPackage rec {
            pname = "esdbclient";
            version = "1.1.3";
            src = python.pkgs.fetchPypi {
              inherit pname version;
              sha256 = "sha256-vkDtkU4yLKlU0nmlbssKK0SJRVS9sk/4F+lG6+2aicY=";
            };
            format = "pyproject";

            nativeBuildInputs = with python.pkgs; [ pip poetry-core ];
            propagatedBuildInputs = with python.pkgs; [
              coverage
              dnspython
              grpcio
              typing-extensions
            ];

            meta = with pkgs.lib; {
              inherit description license homepage maintainers;
            };

            postUnpack = ''
              sed -i 's|coverage = "^7.2.7"|coverage = "^7.2.1"|g' $sourceRoot/pyproject.toml
            '';
          };

      in rec {
        defaultPackage = packages.default;
        devShells = {
          default = devShells.esdbclient-python312;
          esdbclient-python39 = shared.devShell-for {
            package = packages.esdbclient-python39;
            python = pkgs.python39;
            inherit pkgs nixpkgsRelease;
          };
          esdbclient-python310 = shared.devShell-for {
            package = packages.esdbclient-python310;
            python = pkgs.python310;
            inherit pkgs nixpkgsRelease;
          };
          esdbclient-python311 = shared.devShell-for {
            package = packages.esdbclient-python311;
            python = pkgs.python311;
            inherit pkgs nixpkgsRelease;
          };
          esdbclient-python312 = shared.devShell-for {
            package = packages.esdbclient-python312;
            python = pkgs.python312;
            inherit pkgs nixpkgsRelease;
          };
          esdbclient-python313 = shared.devShell-for {
            package = packages.esdbclient-python313;
            python = pkgs.python313;
            inherit pkgs nixpkgsRelease;
          };
        };
        packages = {
          default = packages.esdbclient-python312;
          esdbclient-python39 = esdbclient-for pkgs.python39;
          esdbclient-python310 = esdbclient-for pkgs.python310;
          esdbclient-python311 = esdbclient-for pkgs.python311;
          esdbclient-python312 = esdbclient-for pkgs.python312;
          esdbclient-python313 = esdbclient-for pkgs.python313;
        };
      });
}
