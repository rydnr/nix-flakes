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
            bstr = bstr-flake.packages.${system}.bstr;
            cargo2nix = cargo2nix;
          };
          tiktoken = packages.tiktoken-0_3_3;
          default = packages.tiktoken;
        };
        devShell = pkgs.mkShell {
          buildInputs = with pkgs.python3Packages; [ packages.default ];
        };
        shell = flake-utils.lib.mkShell {
          packages = system: [ self.packages.${system}.default ];
        };
      });
}
