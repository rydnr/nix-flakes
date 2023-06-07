{
  description = "rydnr's nix flake collection.";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    overrides = {
      url = "path:./overrides";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
    };
    pympler = {
      url = "path:./pympler";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
    };
  };
  outputs = { self, ... }@inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixos { inherit system; };
        description = "rydnr's nix flake collection";
        license = pkgs.lib.licenses.gplv3;
        homepage = "https://github.com/rydnr/nix-flakes";
        maintainers = with pkgs.lib.maintainers; [ ];
      in rec {
        packages = overrides.packages.${system} // pympler.packages.${system};
        defaultPackage =
          overrides.packages.${system}.overrides-latest-python310;
        devShells = overrides.devShells.${system}
          // pympler.devShells.${system};
      });
}
