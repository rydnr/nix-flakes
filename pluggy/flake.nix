{
  description = "Nix flake for pluggy";

  inputs = rec {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    nixos.url = "github:NixOS/nixpkgs/24.05";
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixos { inherit system; };
        description = "A minimalist production ready plugin system ";
        license = pkgs.lib.licenses.gpl3;
        homepage = "https://github.com/pytest-dev/pluggy";
        maintainers = with pkgs.lib.maintainers; [ ];
        nixpkgsRelease = "nixos-23.05";
        shared = import ../shared.nix;
        pluggy-for = python:
          python.pkgs.buildPythonPackage rec {
            pname = "pluggy";
            version = "1.0.0";
            src = python.pkgs.fetchPypi {
              inherit pname version;
              sha256 = "sha256-QiQ3O6zOVflVqHi/nPp2PB42CFjjMAcgWeELrWhTEVk=";
            };
            format = "pyproject";

            nativeBuildInputs = with python.pkgs; [ setuptools wheel ];

            buildInputs = with python.pkgs; [ setuptools setuptools-scm ];

            checkInputs = with python.pkgs; [ pytest ];

            pythonImportsCheck = [ ];

            meta = with pkgs.lib; {
              inherit description license homepage maintainers;
            };
          };
      in rec {
        defaultPackage = packages.default;
        devShells = rec {
          default = pluggy-python312;
          pluggy-python39 = shared.devShell-for {
            package = packages.pluggy-python39;
            python = pkgs.python39;
            inherit pkgs nixpkgsRelease;
          };
          pluggy-python310 = shared.devShell-for {
            package = packages.pluggy-python310;
            python = pkgs.python310;
            inherit pkgs nixpkgsRelease;
          };
          pluggy-python311 = shared.devShell-for {
            package = packages.pluggy-python311;
            python = pkgs.python311;
            inherit pkgs nixpkgsRelease;
          };
          pluggy-python312 = shared.devShell-for {
            package = packages.pluggy-python312;
            python = pkgs.python312;
            inherit pkgs nixpkgsRelease;
          };
          pluggy-python313 = shared.devShell-for {
            package = packages.pluggy-python313;
            python = pkgs.python313;
            inherit pkgs nixpkgsRelease;
          };
        };
        packages = rec {
          default = pluggy-python312;
          pluggy-python39 = pluggy-for pkgs.python39;
          pluggy-python310 = pluggy-for pkgs.python310;
          pluggy-python311 = pluggy-for pkgs.python311;
          pluggy-python312 = pluggy-for pkgs.python312;
          pluggy-python313 = pluggy-for pkgs.python313;
        };
      });
}
