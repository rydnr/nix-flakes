{
  description = "A Nix flake for bstr 1.0.1 Rust package";

  inputs = {
    cargo2nix.url = "github:cargo2nix/cargo2nix/release-0.11.0";
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-22.11";
      follows = "cargo2nix/nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
      follows = "cargo2nix/flake-utils";
    };
  };

  outputs = inputs:
    with inputs; # pass through all inputs and bring them into scope

    # Build the output set for each default system and map system sets into
    # attributes, resulting in paths such as:
    # nix build .#packages.x86_64-linux.<name>
    flake-utils.lib.eachDefaultSystem (system:

      # let-in expressions, very similar to Rust's let bindings.  These names
      # are used to express the output but not themselves paths in the output.
      let

        # create nixpkgs that contains rustBuilder from cargo2nix overlay
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ cargo2nix.overlays.default ];
        };

        workspace = pkgs.fetchFromGitHub {
          owner = "BurntSushi";
          repo = "bstr";
          rev = "1.0.1";
          sha256 = "sha256-Yhf9lFZMXCGLvkq1yQBzjquSDzACkveRnoLgp8e6Xew=";
        };

        # create the workspace & dependencies package set
        rustPkgs = pkgs.rustBuilder.makePackageSet {
          rustVersion = "1.61.0";
          packageFun = import ./Cargo.nix;
          workspaceSrc = workspace;
        };

      in rec {
        packages = {
          bstr-1_0_1-src = workspace;
          bstr-1_0_1 = (rustPkgs.workspace.bstr { }).bin;

          bstr-src = packages.bstr-1_0_1-src;
          bstr = packages.bstr-1_0_1;
          default-src = packages.bstr-src;
          default = packages.bstr;
        };
        devShell =
          pkgs.mkShell { buildInputs = [ packages.${system}.default ]; };
        shell = flake-utils.lib.mkShell {
          packages = system: [ self.packages.${system}.default ];
        };
      });
}
