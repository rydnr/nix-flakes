{
  description = "Flake for nixpkgs' unidiff.";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixos { inherit system; };
      in rec {
        defaultPackage = packages.default;
        packages = rec {
          default = unidiff-python311;
          unidiff-python38 = pkgs.python38.pkgs.unidiff;
          unidiff-python39 = pkgs.python39.pkgs.unidiff;
          unidiff-python310 = pkgs.python310.pkgs.unidiff;
          unidiff-python311 = pkgs.python311.pkgs.unidiff;
        };
      });
}
