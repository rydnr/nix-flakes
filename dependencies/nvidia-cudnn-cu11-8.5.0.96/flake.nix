{
  description = "A Nix flake for nvidia-cudnn-cu11 8.5.0.96 Python package";

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
          nvidia-cudnn-cu11-8.5.0.96 = (import ./nvidia-cudnn-cu11-8.5.0.96.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi
             inherit (pkgs) lib;
          };
          nvidia-cudnn-cu11 = packages.nvidia-cudnn-cu11-8.5.0.96;
          default = packages.nvidia-cudnn-cu11;
          meta = with lib; {
            description = ''
cuDNN runtime libraries containing primitives for deep neural networks.

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
