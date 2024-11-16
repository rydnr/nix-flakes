{
  description = "Flake for nixpkgs' joblib.";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/24.05";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixos { inherit system; };
      in rec {
        defaultPackage = packages.default;
        packages = rec {
          default = joblib-python312;
          joblib-python38 = pkgs.python38.pkgs.joblib;
          joblib-python39 = pkgs.python39.pkgs.joblib;
          joblib-python310 = pkgs.python310.pkgs.joblib;
          joblib-python311 = pkgs.python311.pkgs.joblib;
          joblib-python312 = pkgs.python312.pkgs.joblib;
        };
      });
}
