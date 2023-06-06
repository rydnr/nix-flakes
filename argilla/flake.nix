{
  description = "Open-source data curation platform for LLMs";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    flit = {
      url = "github:rydnr/nix-flakes/flit-3.9.0?dir=flit";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
    };
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixos { inherit system; };
        python = pkgs.python3;
        pythonPackages = python.pkgs;
        description = "Open-source data curation platform for LLMs";
        license = pkgs.lib.licenses.asl20;
        homepage = "https://www.argilla.io";
        maintainers = with pkgs.lib.maintainers; [ ];
      in rec {
        packages = {
          argilla = pythonPackages.buildPythonPackage rec {
            pname = "tomli";
            version = "2.0.1";
            src = pythonPackages.fetchPypi {
              inherit pname version;
              sha256 = "sha256-3lJsEpFPDFUNFZJMYtcqvEjW/nNkqocygzejEAf+ik8=";
            };
            format = "pyproject";

            nativeBuildInputs = [ flit.packages.${system}.flit-core ];

            meta = with pkgs.lib; {
              inherit description license homepage maintainers;
            };
          };
          default = packages.argilla;
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
