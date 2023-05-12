{
  description = "A Nix flake for nvidia-cuda-runtime-cu11 11.7.99 Python package";

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
          nvidia-cuda-runtime-cu11-11.7.99 = (import ./nvidia-cuda-runtime-cu11-11.7.99.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi
             inherit (pkgs) lib;
          };
          nvidia-cuda-runtime-cu11 = packages.nvidia-cuda-runtime-cu11-11.7.99;
          default = packages.nvidia-cuda-runtime-cu11;
          meta = with lib; {
            description = ''
CUDA Runtime native Libraries

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
