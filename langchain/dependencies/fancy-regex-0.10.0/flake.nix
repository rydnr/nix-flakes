{
  description = "A Nix flake for fancy-regex 0.10.0 Rust package";

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
          owner = "fancy-regex";
          repo = "fancy-regex";
          rev = "0.10.0";
          sha256 = "sha256-/H5i1DYuznmMa/Wk6DndgtV9PMv4qlQlUDV8XLwxRRU=";
        };

        # create the workspace & dependencies package set
        rustPkgs = pkgs.rustBuilder.makePackageSet {
          rustVersion = "1.61.0";
          packageFun = import ./Cargo.nix;
          workspaceSrc = workspace;
        };

      in rec {
        packages = {
          fancy-regex-1_0_1-src = workspace;
          fancy-regex-1_0_1 = (rustPkgs.workspace.fancy-regex { }).bin;

          fancy-regex-src = packages.fancy-regex-1_0_1-src;
          fancy-regex = packages.fancy-regex-1_0_1;
          default-src = packages.fancy-regex-src;
          default = packages.fancy-regex;

          meta = with lib; {
            description =
              "A Rust library for compiling and matching regular expressions";
            homepage = "https://github.com/fancy-regex/fancy-regex";
            license = licenses.mit;
            maintainers = with maintainers; [ ];
            platforms = platforms.all;
          };
        };
        devShell =
          pkgs.mkShell { buildInputs = [ packages.${system}.default ]; };
        shell = flake-utils.lib.mkShell {
          packages = system: [ self.packages.${system}.default ];
        };
      });
}
