{
  description = "Flake for nixpkgs' dulwich.";

  inputs = rec {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    nixos.url = "github:NixOS/nixpkgs/nixos-23.05";
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixos { inherit system; };
      in rec {
        defaultPackage = packages.default;
        packages = rec {
          default = dulwich-python311;
          dulwich-python38 = pkgs.python38.pkgs.dulwich;
          dulwich-python39 = pkgs.python39.pkgs.dulwich;
          dulwich-python310 = pkgs.python310.pkgs.dulwich;
          dulwich-python311 = pkgs.python311.pkgs.dulwich;
        };
      });
}
