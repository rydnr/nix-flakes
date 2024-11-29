{
  description = "Nix flake for jupyterlab in nixpkgs";

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
          default = jupyterlab-python312;
          jupyterlab-python39 = shared.devShell-for {
            package = packages.jupyterlab-python39;
            python = pkgs.python39;
            inherit pkgs nixpkgsRelease;
          };
          jupyterlab-python310 = shared.devShell-for {
            package = packages.jupyterlab-python310;
            python = pkgs.python310;
            inherit pkgs nixpkgsRelease;
          };
          jupyterlab-python311 = shared.devShell-for {
            package = packages.jupyterlab-python311;
            python = pkgs.python311;
            inherit pkgs nixpkgsRelease;
          };
          jupyterlab-python312 = shared.devShell-for {
            package = packages.jupyterlab-python312;
            python = pkgs.python312;
            inherit pkgs nixpkgsRelease;
          };
          jupyterlab-python313 = shared.devShell-for {
            package = packages.jupyterlab-python313;
            python = pkgs.python313;
            inherit pkgs nixpkgsRelease;
          };
        };
        packages = rec {
          default = jupyterlab-python312;
          jupyterlab-python39 = pkgs.python39.pkgs.jupyterlab;
          jupyterlab-python310 = pkgs.python310.pkgs.jupyterlab;
          jupyterlab-python311 = pkgs.python311.pkgs.jupyterlab;
          jupyterlab-python312 = pkgs.python312.pkgs.jupyterlab;
          jupyterlab-python313 = pkgs.python313.pkgs.jupyterlab;
        };
      });
}
