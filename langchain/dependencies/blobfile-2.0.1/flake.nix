{
  description = "A Nix flake for blobfile 2.0.1 Python package";

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
          blobfile-2_0_1 = (import ./blobfile-2.0.1.nix) {
            inherit (pythonPackages)
              buildPythonPackage astor av filelock imageio lxml pycryptodomex
              pytest tensorflow urllib3 xmltodict;
            inherit (pkgs) lib fetchFromGitHub;
          };
          blobfile = packages.blobfile-2_0_1;
          default = packages.blobfile;
          meta = with lib; {
            description =
              "Python-like interface for reading local and remote files.";
            homepage = "https://github.com/christopher-hesse/blobfile";
            license = licenses.unlicense;
            maintainers = with maintainers; [ ];
            platforms = platforms.all;
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
