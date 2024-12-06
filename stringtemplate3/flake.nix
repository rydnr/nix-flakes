{
  description = "Flake for Stringtemplate3 Python";

  inputs = rec {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    nixpkgs.url = "github:NixOS/nixpkgs/24.05";
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        description = "Python port of Stringtemplate3 template engine.";
        license = pkgs.lib.licenses.bsd3;
        homepage = "https://github.com/antlr/stringtemplate3";
        maintainers = with pkgs.lib.maintainers; [ ];
        nixpkgsRelease = "nixpkgs-24.05";
        shared = import ../shared.nix;
        stringtemplate3-for = { python }:
          python.pkgs.buildPythonPackage rec {
            pname = "stringtemplate3b";
            version = "3.1";
            src = pkgs.fetchFromGitHub {
              owner = "fcarne";
              repo = "stringtemplate3-python3-runtime";
              rev = "cf31a2d";
              sha256 = "sha256-j/T6bIkQu0Ij6Ly9yZcByR49ekZpzNZDTEWLGMGIAaQ=";
            };
            format = "setuptools";

            doCheck = false;
            meta = with lib; {
              inherit description license homepage maintainers;
            };
          };
      in rec {
        defaultPackage = packages.default;
        devShells = rec {
          default = stringtemplate3-python312;
          stringtemplate3-python39 = shared.devShell-for {
            package = packages.stringtemplate3-python39;
            python = pkgs.python39;
            inherit pkgs nixpkgsRelease;
          };
          stringtemplate3-python310 = shared.devShell-for {
            package = packages.stringtemplate3-python310;
            python = pkgs.python310;
            inherit pkgs nixpkgsRelease;
          };
          stringtemplate3-python311 = shared.devShell-for {
            package = packages.stringtemplate3-python311;
            python = pkgs.python311;
            inherit pkgs nixpkgsRelease;
          };
          stringtemplate3-python312 = shared.devShell-for {
            package = packages.stringtemplate3-python312;
            python = pkgs.python312;
            inherit pkgs nixpkgsRelease;
          };
          stringtemplate3-python313 = shared.devShell-for {
            package = packages.stringtemplate3-python313;
            python = pkgs.python313;
            inherit pkgs nixpkgsRelease;
          };
        };
        packages = rec {
          default = stringtemplate3-python312;
          stringtemplate3-python39 =
            stringtemplate3-for { python = pkgs.python39; };
          stringtemplate3-python310 =
            stringtemplate3-for { python = pkgs.python310; };
          stringtemplate3-python311 =
            stringtemplate3-for { python = pkgs.python311; };
          stringtemplate3-python312 =
            stringtemplate3-for { python = pkgs.python312; };
          stringtemplate3-python313 =
            stringtemplate3-for { python = pkgs.python313; };
        };
      });
}
