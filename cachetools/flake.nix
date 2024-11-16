{
  description = "Flake for nixpkgs' cachetools.";

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
          default = cachetools-python311;
          cachetools-python38 = pkgs.python38.pkgs.cachetools;
          cachetools-python39 = pkgs.python39.pkgs.cachetools;
          cachetools-python310 = pkgs.python310.pkgs.cachetools;
          cachetools-python311 = pkgs.python311.pkgs.cachetools;
          cachetools-python312 = pkgs.python312.pkgs.cachetools;
        };
      });
}
