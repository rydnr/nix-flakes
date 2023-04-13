{
  description = "A Nix flake for Jaraco.UI 2.3.0 Python package";

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
          jaraco_ui-2_3_0 = (import ./jaraco_ui-2.3.0.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi jaraco_classes jaraco_text setuptools
              setuptools-scm;
            inherit (pkgs) lib;
          };
          jaraco_ui = packages.jaraco_ui-2_3_0;
          default = packages.jaraco_ui;
          meta = with lib; {
            description = "";
            license = licenses.mit;
            homepage = "https://github.com/jaraco/jaraco.ui";
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
