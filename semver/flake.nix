{
  description = "Nix flake for semver in nixpkgs";

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
          default = semver-python312;
          semver-python39 = shared.devShell-for {
            package = packages.semver-python39;
            python = pkgs.python39;
            inherit pkgs nixpkgsRelease;
          };
          semver-python310 = shared.devShell-for {
            package = packages.semver-python310;
            python = pkgs.python310;
            inherit pkgs nixpkgsRelease;
          };
          semver-python311 = shared.devShell-for {
            package = packages.semver-python311;
            python = pkgs.python311;
            inherit pkgs nixpkgsRelease;
          };
          semver-python312 = shared.devShell-for {
            package = packages.semver-python312;
            python = pkgs.python312;
            inherit pkgs nixpkgsRelease;
          };
          semver-python313 = shared.devShell-for {
            package = packages.semver-python313;
            python = pkgs.python313;
            inherit pkgs nixpkgsRelease;
          };
        };
        packages = rec {
          default = semver-python312;
          semver-python39 = pkgs.python39.pkgs.semver;
          semver-python310 = pkgs.python310.pkgs.semver;
          semver-python311 = pkgs.python311.pkgs.semver;
          semver-python312 = pkgs.python312.pkgs.semver;
          semver-python313 = pkgs.python313.pkgs.semver;
        };
      });
}
