{
  description = "Nix flake for dulwich in nixpkgs";

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
          default = dulwich-python312;
          dulwich-python39 = shared.devShell-for {
            package = packages.dulwich-python39;
            python = pkgs.python39;
            inherit pkgs nixpkgsRelease;
          };
          dulwich-python310 = shared.devShell-for {
            package = packages.dulwich-python310;
            python = pkgs.python310;
            inherit pkgs nixpkgsRelease;
          };
          dulwich-python311 = shared.devShell-for {
            package = packages.dulwich-python311;
            python = pkgs.python311;
            inherit pkgs nixpkgsRelease;
          };
          dulwich-python312 = shared.devShell-for {
            package = packages.dulwich-python312;
            python = pkgs.python312;
            inherit pkgs nixpkgsRelease;
          };
          dulwich-python313 = shared.devShell-for {
            package = packages.dulwich-python313;
            python = pkgs.python313;
            inherit pkgs nixpkgsRelease;
          };
        };
        packages = rec {
          default = dulwich-python312;
          dulwich-python39 = pkgs.python39.pkgs.dulwich;
          dulwich-python310 = pkgs.python310.pkgs.dulwich;
          dulwich-python311 = pkgs.python311.pkgs.dulwich;
          dulwich-python312 = pkgs.python312.pkgs.dulwich;
          dulwich-python313 = pkgs.python313.pkgs.dulwich;
        };
      });
}
