{
  description = "Python gRPC Client for EventStoreDBs";

  inputs = rec {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    nixos.url = "github:NixOS/nixpkgs/24.05";
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixos { inherit system; };
        description = "Python gRPC Client for EventStoreDB";
        license = pkgs.lib.licenses.bsd3;
        homepage = "https://github.com/pyeventsourcing/esdbclient";
        maintainers = with pkgs.lib.maintainers; [ ];
        shellHook-for = package: ''
          export PNAME="${package.pname}";
          export PVERSION="${package.version}";
          export PS1="\[\033[01;32m\][\$PNAME-\$PVERSION]\[\033[00m\] \[\033[01;34m\]\W \$\[\033[00m\] "
        '';
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
          esdbclient-python37 = pkgs.mkShell {
            buildInputs = [ packages.esdbclient-python37 ];
            shellHook = shellHook-for packages.esdbclient-python37;
          };
          esdbclient-python38 = pkgs.mkShell {
            buildInputs = [ packages.esdbclient-python38 ];
            shellHook = shellHook-for packages.esdbclient-python38;
          };
          esdbclient-python39 = pkgs.mkShell {
            buildInputs = [ packages.esdbclient-python39 ];
            shellHook = shellHook-for packages.esdbclient-python39;
          };
          esdbclient-python310 = pkgs.mkShell {
            buildInputs = [ packages.esdbclient-python310 ];
            shellHook = shellHook-for packages.esdbclient-python310;
          };
          esdbclient-python311 = pkgs.mkShell {
            buildInputs = [ packages.esdbclient-python311 ];
            shellHook = shellHook-for packages.esdbclient-python311;
          };
          esdbclient-python312 = pkgs.mkShell {
            buildInputs = [ packages.esdbclient-python312 ];
            shellHook = shellHook-for packages.esdbclient-python312;
          };
        };
        packages = {
          esdbclient-python37 = esdbclient-for pkgs.python37;
          esdbclient-python38 = esdbclient-for pkgs.python38;
          esdbclient-python39 = esdbclient-for pkgs.python39;
          esdbclient-python310 = esdbclient-for pkgs.python310;
          esdbclient-python311 = esdbclient-for pkgs.python311;
          esdbclient-python312 = esdbclient-for pkgs.python312;
          default = packages.esdbclient-python312;
        };
      });
}
