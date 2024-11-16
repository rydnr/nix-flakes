{
  description = "Flake for nixpkgs' jupyterlab.";

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
          default = jupyterlab-python312;
          jupyterlab-python38 = pkgs.python38.pkgs.jupyterlab;
          jupyterlab-python39 = pkgs.python39.pkgs.jupyterlab;
          jupyterlab-python310 = pkgs.python310.pkgs.jupyterlab;
          jupyterlab-python311 = pkgs.python311.pkgs.jupyterlab;
          jupyterlab-python312 = pkgs.python312.pkgs.jupyterlab;
        };
      });
}
