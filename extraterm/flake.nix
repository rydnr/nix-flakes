{
  description = "The swiss army chainsaw of terminal emulators";

  inputs = rec {
    extraterm-src = {
      url = "github:sedwards2009/extraterm/v0.79.0";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    nixos.url = "github:NixOS/nixpkgs/24.05";
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixos { inherit system; };
        description = "The swiss army chainsaw of terminal emulators";
        license = pkgs.lib.licenses.gpl3;
        homepage = "https://github.com/sedwards2009/extraterm";
        maintainers = with pkgs.lib.maintainers; [ ];
        nixpkgsRelease = "nixos-24.05";
        shared = import ./nix/devShells.nix;
        yarn = pkgs.yarn;
        extraterm-for = { nodejs }:
          let name = "extraterm";
          in pkgs.mkYarnPackage rec {
            inherit name nodejs;
            src = extraterm-src;

            packageJSON = extraterm-src + "/package.json";
            yarnLock = extraterm-src + "/yarn.lock";
            meta = { inherit description homepage license maintainers; };
          };
      in rec {
        defaultPackage = packages.default;
        devShells = rec {
          default = extraterm-nodejs22;
          extraterm-nodejs18 = shared.devShell-for {
            package = packages.extraterm-nodejs18;
            python = pkgs.python313;
            inherit pkgs nixpkgsRelease;
          };
          extraterm-nodejs20 = shared.devShell-for {
            package = packages.extraterm-nodejs20;
            python = pkgs.python313;
            inherit pkgs nixpkgsRelease;
          };
          extraterm-nodejs22 = shared.devShell-for {
            package = packages.extraterm-nodejs22;
            python = pkgs.python313;
            inherit pkgs nixpkgsRelease;
          };
        };
        packages = rec {
          default = extraterm-nodejs22;
          extraterm-nodejs18 =
            extraterm-for { nodejs = pkgs.nodejs_18; };
          extraterm-nodejs20 =
            extraterm-for { nodejs = pkgs.nodejs_20; };
          extraterm-nodejs22 =
            extraterm-for { nodejs = pkgs.nodejs_22; };
          extraterm-latest-nodejs18 = extraterm-nodejs18;
          extraterm-latest-nodejs20 = extraterm-nodejs20;
          extraterm-latest-nodejs22 = extraterm-nodejs22;
        };
      });
}
