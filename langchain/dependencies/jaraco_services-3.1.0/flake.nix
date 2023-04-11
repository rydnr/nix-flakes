{
  description = "A Nix flake for Jaraco.Services 3.1.0 Python package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
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
          jaraco_services-3_1_0 = (import ./jaraco_services-3.1.0.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi jaraco_classes path portend python
              setuptools;
            inherit (pkgs) lib stdenv;
          };
          jaraco_services = packages.jaraco_services-3_1_0;
          default = packages.jaraco_services;
          meta = with lib; {
            description = "";
            license = licenses.mit;
            homepage = "https://github.com/jaraco/jaraco.services";
            maintainers = with maintainers; [ ];
          };
        };
        devShell = pkgs.mkShell {
          buildInputs = with pkgs.python3Packages; [ packages.default ];
        };
        shell = flake-utils.lib.mkShell {
          packages = system: [ self.packages.${system}.default ];
        };
      });
}
