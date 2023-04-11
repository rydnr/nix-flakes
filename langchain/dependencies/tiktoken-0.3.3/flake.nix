{
  description = "A Nix flake for Tiktoken 0.3.3 Python package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
    tiktoken-rust-flake.url =
      "github:rydnr/nix-flakes?dir=langchain/dependencies/tiktoken-rust-0.3.3";
    setuptools-rust-flake.url =
      "github:rydnr/nix-flakes?dir=langchain/dependencies/setuptools-rust-1.5.2";
  };

  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python3;
        pythonPackages = python.pkgs;
        # create the workspace & dependencies package set
        workspace = pkgs.fetchFromGitHub {
          owner = "openai";
          repo = "tiktoken";
          rev = "0.3.3";
          hash = "sha256-5YucJjoYAUTRy7oJ3yb2uE1UZDLIPXnV0bJIDgwGOeA=";
        };

      in rec {
        packages = {
          tiktoken-0_3_3 = (import ./tiktoken-0.3.3.nix) {
            inherit (pythonPackages)
              buildPythonPackage regex requests semantic-version
              typing-extensions;
            inherit (pkgs) fetchFromGitHub lib;
            setuptools-rust =
              setuptools-rust-flake.packages.${system}.setuptools-rust;
            tiktoken-rust =
              tiktoken-rust-flake.packages.${system}.tiktoken-rust;
          };
          tiktoken = packages.tiktoken-0_3_3;
          default = packages.tiktoken;
          meta = with lib; {
            description = "Fast BPE tokeniser for use with OpenAI's models.";
            homepage = "https://github.com/openai/tiktoken";
            license = licenses.mit;
            maintainers = with maintainers; [ ];
            platforms = platforms.all;
          };
        };
        devShell =
          pkgs.mkShell { buildInputs = with pkgs; [ packages.default ]; };
        shell = flake-utils.lib.mkShell {
          packages = system: [ self.packages.${system}.default ];
        };
      });
}
