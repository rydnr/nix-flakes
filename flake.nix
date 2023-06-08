{
  description = "rydnr's nix flake collection.";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    exceptiongroup = {
      url = "path:./exceptiongroup";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flit.follows = "flit";
      inputs.flit-scm.follows = "flit-scm";
    };
    flit = {
      url = "path:./flit";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.trove-classifiers.follows = "trove-classifiers";
    };
    flit-scm = {
      url = "path:./flit-scm";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flit.follows = "flit";
    };
    hatchling = {
      url = "path:./hatchling";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.trove-classifiers.follows = "trove-classifiers";
    };
    overrides = {
      url = "path:./overrides";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
    };
    pluggy = {
      url = "path:./pluggy";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
    };
    pympler = {
      url = "path:./pympler";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
    };
    trove-classifiers = {
      url = "path:./trove-classifiers";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
    };
    tomli = {
      url = "path:./tomli";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flit.follows = "flit";
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
        packages = exceptiongroup.packages.${system} // flit.packages.${system}
          // flit-scm.packages.${system} // hatchling.packages.${system}
          // overrides.packages.${system} // pluggy.packages.${system}
          // pympler.packages.${system} // trove-classifiers.packages.${system}
          // tomli.packages.${system};
        defaultPackage =
          exceptiongroup.packages.${system}.exceptiongroup-latest-python310;
      });
}
