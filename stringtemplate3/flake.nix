{
  description = "Python port of Stringtemplate3 template enginge.";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixos { inherit system; };
        description = "Python port of Stringtemplate3 template engine.";
        license = pkgs.lib.licenses.bsd3;
        homepage = "https://github.com/antlr/stringtemplate3";
        maintainers = with pkgs.lib.maintainers; [ ];
        nixpkgsRelease = "nixos-23.05";
        stringtemplate3-for = { python }:
          python.pkgs.buildPythonPackage rec {
            pname = "stringtemplate3b";
            version = "3.1";
            src = pkgs.fetchFromGitHub {
              owner = "fcarne";
              repo = "stringtemplate3-python3-runtime";
              rev = "master";
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
        packages = rec {
          default = stringtemplate3-python312;
          stringtemplate3-python38 =
            stringtemplate3-for { python = pkgs.python38; };
          stringtemplate3-python39 =
            stringtemplate3-for { python = pkgs.python39; };
          stringtemplate3-python310 =
            stringtemplate3-for { python = pkgs.python310; };
          stringtemplate3-python311 =
            stringtemplate3-for { python = pkgs.python311; };
          stringtemplate3-python312 =
            stringtemplate3-for { python = pkgs.python312; };
        };
      });
}
