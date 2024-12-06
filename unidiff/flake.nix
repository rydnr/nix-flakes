{
  description = "Flake for nixpkgs' unidiff";

  inputs = rec {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    nixpkgs.url = "github:NixOS/nixpkgs/24.05";
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
          shared = import ../shared.nix;
      in rec {
        defaultPackage = packages.default;
        devShells = rec {
          default = unidiff-python312;
          unidiff-python39 = shared.devShell-for {
            package = packages.unidiff-python39;
            python = pkgs.python39;
            inherit pkgs nixpkgsRelease;
          };
          unidiff-python310 = shared.devShell-for {
            package = packages.unidiff-python310;
            python = pkgs.python310;
            inherit pkgs nixpkgsRelease;
          };
          unidiff-python311 = shared.devShell-for {
            package = packages.unidiff-python311;
            python = pkgs.python311;
            inherit pkgs nixpkgsRelease;
          };
          unidiff-python312 = shared.devShell-for {
            package = packages.unidiff-python312;
            python = pkgs.python312;
            inherit pkgs nixpkgsRelease;
          };
          unidiff-python313 = shared.devShell-for {
            package = packages.unidiff-python313;
            python = pkgs.python313;
            inherit pkgs nixpkgsRelease;
          };
        };
        packages = rec {
          default = unidiff-python312;
          unidiff-python39 = pkgs.python39.pkgs.unidiff;
          unidiff-python310 = pkgs.python310.pkgs.unidiff;
          unidiff-python311 = pkgs.python311.pkgs.unidiff;
          unidiff-python312 = pkgs.python312.pkgs.unidiff;
          unidiff-python313 = pkgs.python313.pkgs.unidiff;
        };
      });
}
