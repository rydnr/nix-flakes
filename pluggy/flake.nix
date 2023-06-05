{
  description = "A minimalist production ready plugin system ";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixos { inherit system; };
        python = pkgs.python3;
        pythonPackages = python.pkgs;
        description = "A minimalist production ready plugin system ";
        license = pkgs.lib.licenses.gpl3;
        homepage = "https://github.com/pytest-dev/pluggy";
        maintainers = with pkgs.lib.maintainers; [ ];
      in rec {
        packages = {
          pluggy = pythonPackages.buildPythonPackage rec {
            pname = "pluggy";
            version = "1.0.0";
            src = pythonPackages.fetchPypi {
              pname = "pluggy";
              version = "1.0.0";
              sha256 = "sha256-QiQ3O6zOVflVqHi/nPp2PB42CFjjMAcgWeELrWhTEVk=";
            };
            format = "pyproject";

            nativeBuildInputs = with pythonPackages; [ setuptools wheel ];

            buildInputs = with pythonPackages; [ setuptools setuptools-scm ];

            checkInputs = with pythonPackages; [ pytest ];

            pythonImportsCheck = [ ];

            meta = with pkgs.lib; {
              inherit description license homepage maintainers;
            };
          };
          default = packages.pluggy;
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
