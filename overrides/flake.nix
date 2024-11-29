{
  description =
    "A decorator @override that verifies that a method that should override an inherited method actually does it.";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/24.05";
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
        shared = import ../shared.nix;
        overrides-for = python:
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
        defaultPackage = packages.default;
        devShells = rec {
          default = overrides-python312;
          overrides-python39 = shared.devShell-for {
            package = packages.overrides-python39;
            python = pkgs.python39;
            inherit pkgs nixpkgsRelease;
          };
          overrides-python310 = shared.devShell-for {
            package = packages.overrides-python310;
            python = pkgs.python310;
            inherit pkgs nixpkgsRelease;
          };
          overrides-python311 = shared.devShell-for {
            package = packages.overrides-python311;
            python = pkgs.python311;
            inherit pkgs nixpkgsRelease;
          };
          overrides-python312 = shared.devShell-for {
            package = packages.overrides-python312;
            python = pkgs.python312;
            inherit pkgs nixpkgsRelease;
          };
          overrides-python313 = shared.devShell-for {
            package = packages.overrides-python313;
            python = pkgs.python313;
            inherit pkgs nixpkgsRelease;
          };
        };
        packages = rec {
          default = overrides-python312;
        devShells = rec {
          default = overrides-python312;
          overrides-python39 = shared.devShell-for {
            package = packages.overrides-python39;
            python = pkgs.python39;
            inherit pkgs nixpkgsRelease;
          };
          overrides-python310 = shared.devShell-for {
            package = packages.overrides-python310;
            python = pkgs.python310;
            inherit pkgs nixpkgsRelease;
          };
          overrides-python311 = shared.devShell-for {
            package = packages.overrides-python311;
            python = pkgs.python311;
            inherit pkgs nixpkgsRelease;
          };
          overrides-python312 = shared.devShell-for {
            package = packages.overrides-python312;
            python = pkgs.python312;
            inherit pkgs nixpkgsRelease;
          };
          overrides-python313 = shared.devShell-for {
            package = packages.overrides-python313;
            python = pkgs.python313;
            inherit pkgs nixpkgsRelease;
          };
        };
          overrides-python39 = overrides-for pkgs.python39;
          overrides-python310 = overrides-for pkgs.python310;
          overrides-python311 = overrides-for pkgs.python311;
          overrides-python312 = overrides-for pkgs.python312;
          overrides-python313 = overrides-for pkgs.python313;
        };
      });
}
