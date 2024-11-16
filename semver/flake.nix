{
  description = "Flake for nixpkgs' semver.";

  inputs = rec {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    nixos.url = "github:NixOS/nixpkgs/24.05";
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixos { inherit system; };
      in rec {
        defaultPackage = packages.default;
        packages = rec {
          default = semver-python312;
          semver-python38 = pkgs.python38.pkgs.semver;
          semver-python39 = pkgs.python39.pkgs.semver;
          semver-python310 = pkgs.python310.pkgs.semver;
          semver-python311 = pkgs.python311.pkgs.semver;
          semver-python312 = pkgs.python312.pkgs.semver;
        };
      });
}
