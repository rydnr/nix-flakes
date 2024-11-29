{
  description = "Nix flake for joblib in nixpkgs";

  inputs = rec {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    nixos.url = "github:NixOS/nixpkgs/24.05";
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixos { inherit system; };
          nixpkgsRelease = "nixos-24.05";
          shared = import ../shared;
      in rec {
        defaultPackage = packages.default;
        devShells = rec {
          default = joblib-python312;
          joblib-python39 = shared.devShell-for {
            package = packages.joblib-python39;
            python = pkgs.python39;
            inherit pkgs nixpkgsRelease;
          };
          joblib-python310 = shared.devShell-for {
            package = packages.joblib-python310;
            python = pkgs.python310;
            inherit pkgs nixpkgsRelease;
          };
          joblib-python311 = shared.devShell-for {
            package = packages.joblib-python311;
            python = pkgs.python311;
            inherit pkgs nixpkgsRelease;
          };
          joblib-python312 = shared.devShell-for {
            package = packages.joblib-python312;
            python = pkgs.python312;
            inherit pkgs nixpkgsRelease;
          };
          joblib-python313 = shared.devShell-for {
            package = packages.joblib-python313;
            python = pkgs.python313;
            inherit pkgs nixpkgsRelease;
          };
        };
        packages = rec {
          default = joblib-python312;
          joblib-python39 = pkgs.python39.pkgs.joblib;
          joblib-python310 = pkgs.python310.pkgs.joblib;
          joblib-python311 = pkgs.python311.pkgs.joblib;
          joblib-python312 = pkgs.python312.pkgs.joblib;
          joblib-python313 = pkgs.python313.pkgs.joblib;
        };
      });
}
