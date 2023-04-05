{
  description = "A Flake that uses langchain as a dependency";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
    langchain = {
      url = "https://github.com/hwchase17/langchain";
      flake = false;
    };
    nixpkgs-pyproject = {
      url = "github:nix-community/nixpkgs-pyproject";
      flake = false;
    };
    blis-flake.url =
      "github:rydnr/nix-flakes/langchain/dependencies/blis-0.7.9/flake";
  };

  outputs = { self, nixpkgs, flake-utils, langchain, nixpkgs-pyproject }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pythonDependenciesOverlay = self: super: {
          python3Packages = super.python3Packages // {
            blis = self.blis-flake.defaultPackage.${system};
          };
        };
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ pythonDependenciesOverlay ];
        };

        pyproject2nixFile = langchain:
          with pkgs;
          writeTextFile {
            name = "pyproject2nix.toml";
            text = ''
              [tool.pyproject2nix]
              python_version = "3.9"
            '';
            destination = "/pyproject2nix.toml";
          };

        langchainWithPyproject2nix = langchainSrc:
          with pkgs;
          runCommand "langchain-with-pyproject2nix" {
            inherit (langchainSrc) src;
            buildInputs = [ nixpkgs-pyproject ];
            passAsFile = [ "pyproject2nix" ];
          } ''
            cp -r $src $out
            cp $pyproject2nixPath $out/pyproject2nix.toml
            pushd $out
            pyproject2nix
            popd
          '';

        langchainPackage = let
          langchainSrc = langchain;
          langchainWithToml = pyproject2nixFile langchainSrc;
          langchainWithPyproject2nix = langchainWithPyproject2nix langchainSrc;
        in import "${langchainWithPyproject2nix}/default.nix";

      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs.python3Packages; [
            python
            jupyterlab
            numpy
            pandas
            matplotlib
            scipy
            importlib-metadata
            langchain
            blis
          ];
        };
      });
}
