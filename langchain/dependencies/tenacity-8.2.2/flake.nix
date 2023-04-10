{
  description = "A Nix flake for tenacity 8.2.2 Python package";

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
          tenacity-8_2_2 = (import ./tenacity-8.2.2.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi isPy27 isPy3k pbr pytest six futures
              monotonic typing setuptools-scm sphinx tornado typeguard;
            inherit (pkgs) lib;
          };
          tenacity = packages.tenacity-8_2_2;
          default = packages.tenacity;
          meta = with lib; {
            homepage = "https://github.com/jd/tenacity";
            description = "Retrying library for Python";
            license = licenses.asl20;
            maintainers = with maintainers; [ jakewaksbaum ];
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
