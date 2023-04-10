{
  description = "A Nix flake for bstr 1.4.0 Rust package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
    cargo2nix.url = "github:cargo2nix/cargo2nix/release-0.11.0";
    flake-utils.follows = "cargo2nix/flake-utils";
    nixpkgs.follows = "cargo2nix/nixpkgs";
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

        # create the workspace & dependencies package set
        rustPkgs = pkgs.rustBuilder.makePackageSet {
          rustVersion = "1.61.0";
          packageFun = import ./Cargo.nix;
          workspaceSrc = pkgs.fetchFromGitHub {
            owner = "BurntSushi";
            repo = "bstr";
            rev = "1.4.0";
            sha256 = "sha256-BLbnF/p12YPH2JxHS1SJaA+BXGI07HU1s44YpLHBMDc=";
          };
        };

      in rec {
        # the packages in `nix build .#packages.<system>.<name>`
        packages = {
          bstr-1_4_0 = (rustPkgs.workspace.bstr { }).bin;
          # nix build
          default = packages.bstr-1_4_0; # rec
        };
        devShell = pkgs.mkShell { buildInputs = [ packages.default ]; };
        shell = flake-utils.lib.mkShell {
          packages = system: [ self.packages.${system}.bstr-1_4_0 ];
        };
      });
}
