{
  description = "Hatch is a modern, extensible Python project manager.";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    poetry2nix = {
      url = "github:nix-community/poetry2nix/v1.28.0";
      inputs.nixpkgs.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
    };
    python-on-nix = {
      url = "github:on-nix/python/d8a7fa21b76ac3b8a1a3fedb41e86352769b09ed";
      inputs.nixpkgs.follows = "nixos";
    };
    trove-classifiers = {
      url = "github:rydnr/nix-flakes?dir=trove-classifiers/trove-classifiers";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.poetry2nix.follows = "poetry2nix";
    };
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixos { inherit system; };
        python = pkgs.python3;
        pythonPackages = python.pkgs;
        inherit (poetry2nix.legacyPackages.${system}) mkPoetryApplication;
        description = "Hatch is a modern, extensible Python project manager.";
        license = pkgs.lib.licenses.mit;
        homepage = "https://hatch.pypa.io/latest/";
        maintainers = with pkgs.lib.maintainers; [ ];
      in rec {
        packages = {
          hatchling = pythonPackages.buildPythonPackage rec {
            pname = "hatchling";
            version = "1.17.1";
            src = pkgs.fetchFromGitHub {
              owner = "pypa";
              repo = "hatch";
              rev = "hatchling-v1.17.1";
              sha256 = "sha256-OIHVEf1u/9MCDxggG9XsNLk7Z1WoEC1fOdU5zQcB0FQ=";
            };
            format = "backend";

            buildPhase = ''
              runHook preBuild
              ${python.interpreter} -m build backend
              runHook postBuild
            '';
            nativeBuildInputs = with pythonPackages; [
              build
              pathspec
              python-on-nix.packages.${system}.pluggy-latest-python39
            ];
            buildInputs = with pythonPackages; [
              python-on-nix.packages.${system}.pluggy-latest-python39
              trove-classifiers
            ];
            doCheck = false;

            meta = with pkgs.lib; {
              inherit description license homepage maintainers;
            };
          };
          default = packages.hatchling;
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
