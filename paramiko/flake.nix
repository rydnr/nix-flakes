{
  description = "Flake for nixpkgs' paramiko.";

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
          default = paramiko-python312;
          paramiko-python38 = pkgs.python38.pkgs.paramiko;
          paramiko-python39 = pkgs.python39.pkgs.paramiko;
          paramiko-python310 = pkgs.python310.pkgs.paramiko;
          paramiko-python311 = pkgs.python311.pkgs.paramiko;
          paramiko-python312 = pkgs.python312.pkgs.paramiko;
        };
      });
}
