{
  description = "Nix flake for paramiko in nixpkgs";

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
          default = paramiko-python312;
          paramiko-python39 = shared.devShell-for {
            package = packages.paramiko-python39;
            python = pkgs.python39;
            inherit pkgs nixpkgsRelease;
          };
          paramiko-python310 = shared.devShell-for {
            package = packages.paramiko-python310;
            python = pkgs.python310;
            inherit pkgs nixpkgsRelease;
          };
          paramiko-python311 = shared.devShell-for {
            package = packages.paramiko-python311;
            python = pkgs.python311;
            inherit pkgs nixpkgsRelease;
          };
          paramiko-python312 = shared.devShell-for {
            package = packages.paramiko-python312;
            python = pkgs.python312;
            inherit pkgs nixpkgsRelease;
          };
          paramiko-python313 = shared.devShell-for {
            package = packages.paramiko-python313;
            python = pkgs.python313;
            inherit pkgs nixpkgsRelease;
          };
        };
        packages = rec {
          default = paramiko-python312;
          paramiko-python39 = pkgs.python39.pkgs.paramiko;
          paramiko-python310 = pkgs.python310.pkgs.paramiko;
          paramiko-python311 = pkgs.python311.pkgs.paramiko;
          paramiko-python312 = pkgs.python312.pkgs.paramiko;
          paramiko-python313 = pkgs.python313.pkgs.paramiko;
        };
      });
}
