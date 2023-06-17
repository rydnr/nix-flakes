{
  description = "The swiss army chainsaw of terminal emulators";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    extraterm-src = {
      url = "github:sedwards2009/extraterm/5e4b12e";
      flake = false;
    };
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
        nixpkgsRelease = "nixos-23.05";
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
        packages = rec {
          extraterm-0_121_0-nodejs10 =
            extraterm-for { nodejs = pkgs.nodejs-10_x; };
          extraterm-0_121_0-nodejs18 =
            extraterm-for { nodejs = pkgs.nodejs-18_x; };
          extraterm-0_121_0-nodejs19 =
            extraterm-for { nodejs = pkgs.nodejs-19_x; };
          extraterm-latest-nodejs10 = extraterm-0_121_0-nodejs10;
          extraterm-latest-nodejs18 = extraterm-0_121_0-nodejs18;
          extraterm-latest-nodejs19 = extraterm-0_121_0-nodejs19;
          extraterm-latest = extraterm-latest-nodejs18;
          default = extraterm-latest;
        };
        defaultPackage = packages.default;
        devShells = rec {
          extraterm-0_121_0-nodejs10 = shared.devShell-for {
            package = packages.extraterm-0_121_0-nodejs10;
            python = pkgs.nodejs-10_x;
            inherit pkgs nixpkgsRelease;
          };
          extraterm-0_121_0-nodejs18 = shared.devShell-for {
            package = packages.extraterm-0_121_0-nodejs18;
            python = pkgs.nodejs-18_x;
            inherit pkgs nixpkgsRelease;
          };
          extraterm-0_121_0-nodejs19 = shared.devShell-for {
            package = packages.extraterm-0_121_0-nodejs19;
            python = pkgs.nodejs-19_x;
            inherit pkgs nixpkgsRelease;
          };
          extraterm-latest-nodejs10 = extraterm-0_121_0-nodejs10;
          extraterm-latest-nodejs18 = extraterm-0_121_0-nodejs18;
          extraterm-latest-nodejs19 = extraterm-0_121_0-nodejs19;
          extraterm-latest = extraterm-latest-nodejs18;
          default = extraterm-latest;
        };
      });
}
