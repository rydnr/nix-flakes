{
  description = "Flake for nixpkgs' requests.";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/24.05";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixos { inherit system; };
          shared = import ../shared.nix;
      in rec {
        defaultPackage = packages.default;
        devShells = rec {
          default = requests-python312;
          requests-python39 = shared.devShell-for {
            package = packages.requests-python39;
            python = pkgs.python39;
            inherit pkgs nixpkgsRelease;
          };
          requests-python310 = shared.devShell-for {
            package = packages.requests-python310;
            python = pkgs.python310;
            inherit pkgs nixpkgsRelease;
          };
          requests-python311 = shared.devShell-for {
            package = packages.requests-python311;
            python = pkgs.python311;
            inherit pkgs nixpkgsRelease;
          };
          requests-python312 = shared.devShell-for {
            package = packages.requests-python312;
            python = pkgs.python312;
            inherit pkgs nixpkgsRelease;
          };
          requests-python313 = shared.devShell-for {
            package = packages.requests-python313;
            python = pkgs.python313;
            inherit pkgs nixpkgsRelease;
          };
        };
        packages = rec {
          default = requests-python312;
          requests-python39 = pkgs.python39.pkgs.requests;
          requests-python310 = pkgs.python310.pkgs.requests;
          requests-python311 = pkgs.python311.pkgs.requests;
          requests-python312 = pkgs.python312.pkgs.requests;
          requests-python313 = pkgs.python313.pkgs.requests;
        };
      });
}
