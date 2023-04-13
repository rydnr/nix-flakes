{
  description = "A Nix flake for Jaraco.MongoDB 11.21 Python package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
    jaraco_services-flake.url =
      "github:rydnr/nix-flakes?dir=langchain/dependencies/jaraco_services-3.1.0";
    jaraco_ui-flake.url =
      "github:rydnr/nix-flakes?dir=langchain/dependencies/jaraco_ui-2.3.0";
  };

  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python3;
        pythonPackages = python.pkgs;
      in rec {
        packages = {
          jaraco_mongodb-11_2_1 = (import ./jaraco_mongodb-11.2.1.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi jaraco_collections jaraco_itertools
              jaraco_logging pymongo python python-dateutil pytimeparse
              setuptools setuptools-scm;
            inherit (pkgs) lib;
            jaraco_services =
              jaraco_services-flake.packages.${system}.jaraco_services;
            jaraco_ui = jaraco_ui-flake.packages.${system}.jaraco_ui;
          };
          jaraco_mongodb = packages.jaraco_mongodb-11_2_1;
          default = packages.jaraco_mongodb;
          meta = with lib; {
            description =
              "This package provides an oplog module, which is based on the mongooplog-alt project, which itself is a Python remake of official mongooplog utility, shipped with MongoDB starting from version 2.2 and deprecated in 3.2.";
            license = licenses.mit;
            homepage = "https://github.com/jaraco/jaraco.mongodb";
            maintainers = with maintainers; [ ];
          };
        };
        defaultPackage = packages.default;
        devShell = pkgs.mkShell {
          buildInputs = [
            pythonPackages.build
            jaraco_services-flake.packages.${system}.jaraco_services
          ];
        };
        shell = flake-utils.lib.mkShell {
          packages = system: [ self.packages.${system}.default ];
        };
      });
}
