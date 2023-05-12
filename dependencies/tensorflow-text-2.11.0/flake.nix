{
  description = "A Nix flake for tensorflow-text 2.11.0 Python package";

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
          tensorflow-text-2.11.0 = (import ./tensorflow-text-2.11.0.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi
             inherit (pkgs) lib;
          };
          tensorflow-text = packages.tensorflow-text-2.11.0;
          default = packages.tensorflow-text;
          meta = with lib; {
            description = ''
TF.Text is a TensorFlow library of text related ops, modules, and subgraphs. The
library can perform the preprocessing regularly required by text-based models,
and includes other features useful for sequence modeling not provided by core
TensorFlow.

See the README on GitHub for further documentation.
http://github.com/tensorflow/text



'';
            license = licenses.mit;
            homepage = "None";
            maintainers = with maintainers; [ ];
          };
        };
        defaultPackage = packages.default;
        devShell = pkgs.mkShell {
          buildInputs = with pkgs.python3Packages; [ packages.default ];
        };
        shell = flake-utils.lib.mkShell {
          packages = system: [ self.packages.${system}.default ];
        };
      });
}
