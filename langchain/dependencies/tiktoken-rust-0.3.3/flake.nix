{
  description = "A Nix flake for Tiktoken 0.3.3 Rust package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
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
          tiktoken-rust-0_3_3-src = workspace;
          tiktoken-rust-0_3_3 = (rustPkgs.workspace.tiktoken { }).bin;
          tiktoken-rust-src = packages.tiktoken-rust-0_3_3-src;
          tiktoken-rust = packages.tiktoken-rust-0_3_3;
          default-src = packages.tiktoken-rust-src;
          default = packages.tiktoken-rust;
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
