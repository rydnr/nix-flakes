{
  description = "A Nix flake for Tiktoken 0.3.3 Python package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
    blobfile-flake.url =
      "github:rydnr/nix-flakes?dir=langchain/dependencies/blobfile-2.0.1";
    setuptools-rust-flake.url =
      "github:rydnr/nix-flakes?dir=langchain/dependencies/setuptools-rust-1.5.2";
    bstr-flake.url =
      "github:rydnr/nix-flakes?dir=langchain/dependencies/bstr-1.0.1";
    fancy-regex-flake.url =
      "github:rydnr/nix-flakes?dir=langchain/dependencies/fancy-regex-0.10.0";
    cargo2nix.url = "github:tenx-tech/cargo2nix";
  };

  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        #        pkgs = nixpkgs.legacyPackages.${system};
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ cargo2nix.overlays.default ];
        };
        python = pkgs.python3;
        pythonPackages = python.pkgs;
        # create the workspace & dependencies package set
        workspace = pkgs.fetchFromGitHub {
          owner = "openai";
          repo = "tiktoken";
          rev = "0.3.3";
          hash = "sha256-5YucJjoYAUTRy7oJ3yb2uE1UZDLIPXnV0bJIDgwGOeA=";
        };

        rustPkgs = pkgs.rustBuilder.makePackageSet {
          rustVersion = "1.61.0";
          packageFun = import ./Cargo.nix;
          workspaceSrc = workspace;
        };
      in rec {
        packages = {
          tiktoken-0_3_3 = (import ./tiktoken-0.3.3.nix) {
            inherit (pythonPackages)
              buildPythonPackage regex requests semantic-version
              typing-extensions;
            inherit (pkgs)
              cargo fetchFromGitHub lib rustBuilder rustc rustPlatform;
            blobfile = blobfile-flake.packages.${system}.blobfile;
            setuptools-rust =
              setuptools-rust-flake.packages.${system}.setuptools-rust;
            bstr-src = bstr-flake.packages.${system}.bstr-src;
            fancy-regex-src =
              fancy-regex-flake.packages.${system}.fancy-regex-src;
            rustPkgs = rustPkgs;
            cargo2nix = cargo2nix;
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
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [ # packages.default
            cargo
            rustc
            setuptools-rust-flake.packages.${system}.setuptools-rust
            blobfile-flake.packages.${system}.blobfile
            pythonPackages.regex
            pythonPackages.requests
            pythonPackages.semantic-version
            pythonPackages.setuptools
            pythonPackages.typing-extensions
            bstr-flake.packages.${system}.bstr-src
            fancy-regex-flake.packages.${system}.fancy-regex-src
          ];
        };
        shell = flake-utils.lib.mkShell {
          packages = system: [ self.packages.${system}.default ];
        };
      });
}
