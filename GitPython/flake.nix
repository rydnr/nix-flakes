{
  description = "Flake for nixpkgs' GitPython.";

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
          default = GitPython-python312;
          GitPython-python38 = pkgs.python38.pkgs.GitPython;
          GitPython-python39 = pkgs.python39.pkgs.GitPython;
          GitPython-python310 = pkgs.python310.pkgs.GitPython;
          GitPython-python311 = pkgs.python311.pkgs.GitPython;
          GitPython-python312 = pkgs.python312.pkgs.GitPython;
        };
      });
}
