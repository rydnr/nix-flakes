{
  description = "Flake for nixpkgs' grpcio.";

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
          default = grpcio-python312;
          grpcio-python38 = pkgs.python38.pkgs.grpcio;
          grpcio-python39 = pkgs.python39.pkgs.grpcio;
          grpcio-python310 = pkgs.python310.pkgs.grpcio;
          grpcio-python311 = pkgs.python311.pkgs.grpcio;
          grpcio-python312 = pkgs.python312.pkgs.grpcio;
        };
      });
}
