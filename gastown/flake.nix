{
  description =
    "Multi-agent orchestration system for Claude Code with persistent work tracking";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/25.11";
    flake-utils.url = "github:numtide/flake-utils";
    beads = {
      url = "github:gastownhall/beads";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, beads, }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        beadsPkg = beads.packages.${system}.default;
      in {
        packages = {
          gt = pkgs.buildGoModule rec {
            pname = "gt";
            version = "a3b272e";
            vendorHash = "sha256-V5n/rPzHmnX16gF8E2Wz67BArYRjUetmb73KWnz7lXc=";
            src = pkgs.fetchFromGitHub {
              owner = "gastownhall";
              repo = "gastown";
              rev = version;
              sha256 = vendorHash;
            };

            ldflags = [
              "-X github.com/gastownhall/gastown/internal/cmd.Build=nix"
              "-X github.com/steveyegge/gastown/internal/cmd.BuiltProperly=1"
            ];

            subPackages = [ "cmd/gt" ];

            meta = with pkgs.lib; {
              description =
                "Multi-agent orchestration system for Claude Code with persistent work tracking";
              homepage = "https://github.com/gastownhall/gastown";
              license = licenses.mit;
              mainProgram = "gt";
            };
          };
          default = self.packages.${system}.gt;
        };

        apps = {
          gt = flake-utils.lib.mkApp { drv = self.packages.${system}.gt; };
          default = self.apps.${system}.gt;
        };

        devShells.default = pkgs.mkShell {
          buildInputs =
            [ beadsPkg pkgs.go_1_25 pkgs.gopls pkgs.gotools pkgs.go-tools ];
        };
      });
}
