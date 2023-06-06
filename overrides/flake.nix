{
  description =
    "A decorator @override that verifies that a method that should override an inherited method actually does it.";

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
          "A decorator @override that verifies that a method that should override an inherited method actually does it.";
        license = pkgs.lib.licenses.asl20;
        homepage = "https://github.com/mkorpela/overrides";
        maintainers = with pkgs.lib.maintainers; [ ];
        shellHook-for = package: ''
          export PNAME="${package.pname}";
          export PVERSION="${package.version}";
          export PS1="\[\033[01;32m\][\$PNAME-\$PVERSION]\[\033[00m\] \[\033[01;34m\]\W \$\[\033[00m\] "
        '';

        overrides-7_3_1-for = python:
          python.pkgs.buildPythonPackage rec {
            pname = "overrides";
            version = "7.3.1";
            src = python.pkgs.fetchPypi {
              inherit pname version;
              sha256 = "sha256-i5fGweFoG3jLyUJLE42IDwgDwiVMXrqr3eV7tsYgk/I=";
            };

            doCheck = false;
            meta = with pkgs.lib; {
              inherit description license homepage maintainers;
            };
          };
      in rec {
        packages = {
          overrides-7_3_1-python37 = overrides-7_3_1-for pkgs.python37;
          overrides-7_3_1-python38 = overrides-7_3_1-for pkgs.python38;
          overrides-7_3_1-python39 = overrides-7_3_1-for pkgs.python39;
          overrides-7_3_1-python310 = overrides-7_3_1-for pkgs.python310;
          latest-python37 = packages.overrides-7_3_1-python37;
          latest-python38 = packages.overrides-7_3_1-python38;
          latest-python39 = packages.overrides-7_3_1-python39;
          latest-python310 = packages.overrides-7_3_1-python310;
          latest = packages.latest-python310;
          default = packages.latest;
        };
        defaultPackage = packages.default;
        devShells = {
          overrides-7_3_1-python37 = pkgs.mkShell {
            buildInputs = [ packages.overrides-7_3_1-python37 ];
            shellHook = shellHook-for packages.latest-python37;
          };
          overrides-7_3_1-python38 = pkgs.mkShell {
            buildInputs = [ packages.overrides-7_3_1-python38 ];
            shellHook = shellHook-for packages.latest-python38;
          };
          overrides-7_3_1-python39 = pkgs.mkShell {
            buildInputs = [ packages.overrides-7_3_1-python39 ];
            shellHook = shellHook-for packages.latest-python39;
          };
          overrides-7_3_1-python310 = pkgs.mkShell {
            buildInputs = [ packages.overrides-7_3_1-python310 ];
            shellHook = shellHook-for packages.latest-python310;
          };
          latest-python37 = devShells.overrides-7_3_1-python37;
          latest-python38 = devShells.overrides-7_3_1-python38;
          latest-python39 = devShells.overrides-7_3_1-python39;
          latest-python310 = devShells.overrides-7_3_1-python310;
          latest = devShells.latest-python310;
          default = devShells.latest;
        };
      });
}
