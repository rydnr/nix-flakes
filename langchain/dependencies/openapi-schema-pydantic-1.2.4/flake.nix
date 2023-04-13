{
  description = "A Nix flake for openapi-schema-pydantic 1.2.4 Python package";

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
          openapi-schema-pydantic-1_2_4 =
            (import ./openapi-schema-pydantic-1.2.4.nix) {
              inherit (pythonPackages)
                buildPythonPackage fetchPypi pydantic pytest setuptools
                setuptools-scm;
              inherit (pkgs) lib;
            };
          openapi-schema-pydantic = packages.openapi-schema-pydantic-1_2_4;
          default = packages.openapi-schema-pydantic;
          meta = with lib; {
            description =
              "OpenAPI (v3) specification schema as Pydantic classes.";
            license = licenses.mit;
            homepage = "https://github.com/kuimono/openapi-schema-pydantic";
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
