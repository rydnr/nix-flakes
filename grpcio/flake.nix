{
  description = "Nix flake for grpcio in nixpkgs";

  inputs = rec {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    nixpkgs.url = "github:NixOS/nixpkgs/24.05";
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
          nixpkgsRelease = "nixpkgs-24.05";
          shared = import ../shared;
      in rec {
        defaultPackage = packages.default;
        devShells = rec {
          default = grpcio-python312;
          grpcio-python39 = shared.devShell-for {
            package = packages.grpcio-python39;
            python = pkgs.python39;
            inherit pkgs nixpkgsRelease;
          };
          grpcio-python310 = shared.devShell-for {
            package = packages.grpcio-python310;
            python = pkgs.python310;
            inherit pkgs nixpkgsRelease;
          };
          grpcio-python311 = shared.devShell-for {
            package = packages.grpcio-python311;
            python = pkgs.python311;
            inherit pkgs nixpkgsRelease;
          };
          grpcio-python312 = shared.devShell-for {
            package = packages.grpcio-python312;
            python = pkgs.python312;
            inherit pkgs nixpkgsRelease;
          };
          grpcio-python313 = shared.devShell-for {
            package = packages.grpcio-python313;
            python = pkgs.python313;
            inherit pkgs nixpkgsRelease;
          };
        };
        packages = rec {
          default = grpcio-python312;
          grpcio-python39 = pkgs.python39.pkgs.grpcio;
          grpcio-python310 = pkgs.python310.pkgs.grpcio;
          grpcio-python311 = pkgs.python311.pkgs.grpcio;
          grpcio-python312 = pkgs.python312.pkgs.grpcio;
          grpcio-python313 = pkgs.python313.pkgs.grpcio;
        };
      });
}
