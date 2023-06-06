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
        description =
          "Pympler is a development tool to measure, monitor and analyze the memory behavior of Python objects in a running Python application.";
        license = pkgs.lib.licenses.asl20;
        homepage = "https://github.com/pympler/pympler";
        maintainers = with pkgs.lib.maintainers; [ ];
        shellHook-for = package: ''
          export PNAME="${package.pname}";
          export PVERSION="${package.version}";
          export PS1="\[\033[01;32m\][\$PNAME-\$PVERSION]\[\033[00m\] \[\033[01;34m\]\W \$\[\033[00m\] "
        '';
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
          pympler-1_0_1-python37 = pympler-1_0_1-for pkgs.python37;
          pympler-1_0_1-python38 = pympler-1_0_1-for pkgs.python38;
          pympler-1_0_1-python39 = pympler-1_0_1-for pkgs.python39;
          pympler-1_0_1-python310 = pympler-1_0_1-for pkgs.python310;
          latest-python37 = packages.pympler-1_0_1-python37;
          latest-python38 = packages.pympler-1_0_1-python38;
          latest-python39 = packages.pympler-1_0_1-python39;
          latest-python310 = packages.pympler-1_0_1-python310;
          latest = packages.pympler-1_0_1-python310;
          default = packages.latest;
        };
        defaultPackage = packages.default;
        devShells = {
          pympler-1_0_1-python37 = pkgs.mkShell {
            buildInputs = [ packages.pympler-1_0_1-python37 ];
            shellHook = shellHook-for packages.latest-python37;
          };
          pympler-1_0_1-python38 = pkgs.mkShell {
            buildInputs = [ packages.pympler-1_0_1-python38 ];
            shellHook = shellHook-for packages.latest-python38;
          };
          pympler-1_0_1-python39 = pkgs.mkShell {
            buildInputs = [ packages.pympler-1_0_1-python39 ];
            shellHook = shellHook-for packages.latest-python39;
          };
          pympler-1_0_1-python310 = pkgs.mkShell {
            buildInputs = [ packages.pympler-1_0_1-python310 ];
            shellHook = shellHook-for packages.latest-python310;
          };
          latest-python37 = devShells.pympler-1_0_1-python37;
          latest-python38 = devShells.pympler-1_0_1-python38;
          latest-python39 = devShells.pympler-1_0_1-python39;
          latest-python310 = devShells.pympler-1_0_1-python310;
          latest = devShells.latest-python310;
          default = devShells.latest;
        };
      });
}
