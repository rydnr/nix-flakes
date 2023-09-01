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
            pname = "stringtemplate3";
            version = "3.1";
            src = python.pkgs.fetchPypi {
              inherit pname version;
              sha256 = "sha256-Ywv4qKbsHXAlH1UskpG1CBFncbvoxhBAX1g+JpMo7qs=";
            };

            doCheck = false;
            meta = with lib; {
              inherit description license homepage maintainers;
            };
          };
      in rec {
        defaultPackage = packages.default;
        packages = rec {
          default = stringtemplate3-python310;
          stringtemplate3-python38 =
            stringtemplate3-for { python = pkgs.python38; };
          stringtemplate3-python39 =
            stringtemplate3-for { python = pkgs.python39; };
          stringtemplate3-python310 =
            stringtemplate3-for { python = pkgs.python310; };
        };
      });
}
