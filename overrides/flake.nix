{
  description =
    "A decorator @override that verifies that a method that should override an inherited method actually does it.";

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
          "A decorator @override that verifies that a method that should override an inherited method actually does it.";
        license = pkgs.lib.licenses.asl20;
        homepage = "https://github.com/mkorpela/overrides";
        maintainers = with pkgs.lib.maintainers; [ ];
        nixpkgsRelease = "nixos-23.05";
        shared = import ./shared.nix;
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
        packages = rec {
          overrides-7_3_1-python38 = overrides-7_3_1-for pkgs.python38;
          overrides-7_3_1-python39 = overrides-7_3_1-for pkgs.python39;
          overrides-7_3_1-python310 = overrides-7_3_1-for pkgs.python310;
          overrides-7_3_1-python311 = overrides-7_3_1-for pkgs.python311;
          overrides-latest-python38 = overrides-7_3_1-python38;
          overrides-latest-python39 = overrides-7_3_1-python39;
          overrides-latest-python310 = overrides-7_3_1-python310;
          overrides-latest-python311 = overrides-7_3_1-python311;
          overrides-latest = overrides-latest-python311;
          default = overrides-latest;
        };
        defaultPackage = packages.default;
        devShells = rec {
          overrides-7_3_1-python38 = shared.devShell-for {
            package = packages.overrides-7_3_1-python38;
            python = pkgs.python38;
            inherit pkgs nixpkgsRelease;
          };
          overrides-7_3_1-python39 = shared.devShell-for {
            package = packages.overrides-7_3_1-python39;
            python = pkgs.python39;
            inherit pkgs nixpkgsRelease;
          };
          overrides-7_3_1-python310 = shared.devShell-for {
            package = packages.overrides-7_3_1-python310;
            python = pkgs.python310;
            inherit pkgs nixpkgsRelease;
          };
          overrides-7_3_1-python311 = shared.devShell-for {
            package = packages.overrides-7_3_1-python311;
            python = pkgs.python311;
            inherit pkgs nixpkgsRelease;
          };
          overrides-latest-python38 = overrides-7_3_1-python38;
          overrides-latest-python39 = overrides-7_3_1-python39;
          overrides-latest-python310 = overrides-7_3_1-python310;
          overrides-latest-python311 = overrides-7_3_1-python311;
          overrides-latest = overrides-latest-python311;
          default = overrides-latest;
        };
      });
}
