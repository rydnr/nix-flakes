{
  description = "Flake for Claude Code";

  inputs = rec {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.05";
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pname = "claude-code";
        version = "0.2.29";
        url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
        hash = "sha256-1iKDtTE+cHXMW/3zxfsNFjMGMxJlIBzGEXWtTfQfSMM=";
        npmDepsHash = "sha256-fuJE/YTd9apAd1cooxgHQwPda5js44EmSfjuRVPbKdM=";
        pkgs = import nixpkgs { inherit system; };
        description = "Claude Code";
        homepage = "https://anthropic.com";
        maintainers = with pkgs.lib.maintainers; [ ];
        nixpkgsVersion = builtins.readFile "${nixpkgs}/.version";
        nixpkgsRelease =
          builtins.replaceStrings [ "\n" ] [ "" ] "nixpkgs-${nixpkgsVersion}";
        shared = import ../shared.nix;
        claude-code-for = { nodejs }: nodejs.buildNpmPackage rec {
          inherit hash pname nodejs npmDepsHash url version;
          src = fetchurl {
            inherit url hash;
          };
          makeCacheWritable = true;

          postPatch = ''
                if [ -f "${./claude-code/package-lock.json}" ]; then
                  echo "Using vendored package-lock.json"
                  cp "${./claude-code/package-lock.json}" ./package-lock.json
                else
                  echo "No vendored package-lock.json found, creating a minimal one"
                  exit 1
                fi
                '';

          dontNpmBuild = true;
          dontNpmInstall = true;

          nativeBuildInputs = [ makeWrapper ];

          # Create a custom installation phase to handle the package organization
          installPhase = ''
                # Create a directory for the lib files
                mkdir -p $out/lib/node_modules/@anthropic-ai/claude-code

                # Copy all package files to the lib directory
                cp -a . $out/lib/node_modules/@anthropic-ai/claude-code/

                # Create bin directory
                mkdir -p $out/bin

                # Create a wrapper script that points to the actual CLI script
                makeWrapper ${nodejs}/bin/node $out/bin/claude-code \
                  --add-flags "$out/lib/node_modules/@anthropic-ai/claude-code/cli.mjs"
                '';

          meta = with lib; {
            description = "Claude Code CLI tool";
            homepage = "https://www.anthropic.com/claude-code";
            mainProgram = "claude-code";
          };
        };
      in rec {
        defaultPackage = packages.default;
        devShells = rec {
          default = claude-code-nodejs12;
          claude-code-nodejs12 = shared.devShell-for {
            package = packages.claude-code-nodejs12;
            python = pkgs.python3;
            inherit pkgs nixpkgsRelease;
          };
        };
        packages = rec {
          default = claude-code-nodejs12;
          claude-code-nodejs12 = claude-code-for { nodejs = pkgs.nodejs12; };
        };
      });
}
