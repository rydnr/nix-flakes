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
      in rec {
        defaultPackage = packages.default;
        packages = rec {
          default = requests-python312;
          requests-python38 = pkgs.python38.pkgs.requests;
          requests-python39 = pkgs.python39.pkgs.requests;
          requests-python310 = pkgs.python310.pkgs.requests;
          requests-python311 = pkgs.python311.pkgs.requests;
          requests-python312 = pkgs.python312.pkgs.requests;
        };
      });
}
