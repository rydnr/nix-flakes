{
  description = "Nix flake for cachetools in nixpkgs";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/24.05";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
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
          default = cachetools-python312;
          cachetools-python39 = shared.devShell-for {
            package = packages.cachetools-python39;
            python = pkgs.python39;
            inherit pkgs nixpkgsRelease;
          };
          cachetools-python310 = shared.devShell-for {
            package = packages.cachetools-python310;
            python = pkgs.python310;
            inherit pkgs nixpkgsRelease;
          };
          cachetools-python311 = shared.devShell-for {
            package = packages.cachetools-python311;
            python = pkgs.python311;
            inherit pkgs nixpkgsRelease;
          };
          cachetools-python312 = shared.devShell-for {
            package = packages.cachetools-python312;
            python = pkgs.python312;
            inherit pkgs nixpkgsRelease;
          };
          cachetools-python313 = shared.devShell-for {
            package = packages.cachetools-python313;
            python = pkgs.python313;
            inherit pkgs nixpkgsRelease;
          };
        };
        packages = rec {
          default = cachetools-python311;
          cachetools-python39 = pkgs.python39.pkgs.cachetools;
          cachetools-python310 = pkgs.python310.pkgs.cachetools;
          cachetools-python311 = pkgs.python311.pkgs.cachetools;
          cachetools-python312 = pkgs.python312.pkgs.cachetools;
          cachetools-python313 = pkgs.python313.pkgs.cachetools;
        };
      });
}
