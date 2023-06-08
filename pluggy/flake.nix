{
  description = "A minimalist production ready plugin system ";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
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
        shared = import ./shared.nix;
        pluggy-1_0_0-for = python:
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
        packages = rec {
          pluggy-1_0_0-python38 = pluggy-1_0_0-for pkgs.python38;
          pluggy-1_0_0-python39 = pluggy-1_0_0-for pkgs.python39;
          pluggy-1_0_0-python310 = pluggy-1_0_0-for pkgs.python310;
          pluggy-1_0_0-python311 = pluggy-1_0_0-for pkgs.python311;
          pluggy-latest-python38 = pluggy-1_0_0-python38;
          pluggy-latest-python39 = pluggy-1_0_0-python39;
          pluggy-latest-python310 = pluggy-1_0_0-python310;
          pluggy-latest-python311 = pluggy-1_0_0-python311;
          pluggy-latest = pluggy-latest-python311;
          default = pluggy-latest;
        };
        defaultPackage = packages.default;
        devShells = rec {
          pluggy-1_0_0-python38 = shared.devShell-for {
            package = packages.pluggy-1_0_0-python38;
            python = pkgs.python38;
            inherit pkgs nixpkgsRelease;
          };
          pluggy-1_0_0-python39 = shared.devShell-for {
            package = packages.pluggy-1_0_0-python39;
            python = pkgs.python39;
            inherit pkgs nixpkgsRelease;
          };
          pluggy-1_0_0-python310 = shared.devShell-for {
            package = packages.pluggy-1_0_0-python310;
            python = pkgs.python310;
            inherit pkgs nixpkgsRelease;
          };
          pluggy-1_0_0-python311 = shared.devShell-for {
            package = packages.pluggy-1_0_0-python311;
            python = pkgs.python311;
            inherit pkgs nixpkgsRelease;
          };
          pluggy-latest-python38 = pluggy-1_0_0-python38;
          pluggy-latest-python39 = pluggy-1_0_0-python39;
          pluggy-latest-python310 = pluggy-1_0_0-python310;
          pluggy-latest-python311 = pluggy-1_0_0-python311;
          pluggy-latest = pluggy-latest-python311;
          default = pluggy-latest;
        };
      });
}
