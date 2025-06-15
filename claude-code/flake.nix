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
        version = "1.0.24";
        url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
        hash = "sha256-VXPrvA7yM7tpZ4wAbsMtTPL5TRMkNlqp6inLPiihI7I=";
        npmDepsHash = "sha256-iNo/7uHncUpUzYTEUbzvtbdZe+5sMJ3Cd4PaV9Ers1g=";
        pkgs = import nixpkgs { inherit system; };
        description = "Claude Code";
        entrypoint = "claude-code";
        homepage = "https://anthropic.com";
        license = licenses.unfree;
        maintainers = with pkgs.lib.maintainers; [ ];
        nixpkgsVersion = builtins.readFile "${nixpkgs}/.version";
        nixpkgsRelease =
          builtins.replaceStrings [ "\n" ] [ "" ] "nixpkgs-${nixpkgsVersion}";
        shared = import ../shared.nix;
        claude-code-for = { nodejs }: pkgs.buildNpmPackage rec {
          inherit hash pname nodejs npmDepsHash url version;
          src = pkgs.fetchurl {
            inherit url hash;
          };
          dontNpmBuild = true;
          dontNpmInstall = true;
          forceEmptyCache = true;
          makeCacheWritable = true;
          nativeBuildInputs = with pkgs; [ makeWrapper ];

          postPatch = ''
            ${nodejs}/bin/npm install --package-lock-only --ignore-scripts
                '';

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
              --add-flags "$out/lib/node_modules/@anthropic-ai/claude-code/cli.js"
            '';

          meta = {
            description = "Claude Code CLI tool";
            homepage = "https://www.anthropic.com/claude-code";
            #license = pkgs.lib.licenses.unfree;
            mainProgram = entrypoint;
          };
        };
      in rec {
        apps = rec {
          default = claude-code-nodejs24;
          claude-code-nodejs24 = shared.app-for {
            package = self.packages.${system}.claude-code-nodejs24;
            inherit entrypoint;
          };
          claude-code-nodejs22 = shared.app-for {
            package = self.packages.${system}.claude-code-nodejs22;
            inherit entrypoint;
          };
          claude-code-nodejs20 = shared.app-for {
            package = self.packages.${system}.claude-code-nodejs20;
            inherit entrypoint;
          };
          claude-code-nodejs18 = shared.app-for {
            package = self.packages.${system}.claude-code-nodejs18;
            inherit entrypoint;
          };
        };
        defaultPackage = packages.default;
        devShells = rec {
          default = claude-code-nodejs24;
          claude-code-nodejs18 = shared.devShell-for {
            package = packages.claude-code-nodejs18;
            python = pkgs.python3;
            inherit pkgs nixpkgsRelease;
          };
          claude-code-nodejs20 = shared.devShell-for {
            package = packages.claude-code-nodejs20;
            python = pkgs.python3;
            inherit pkgs nixpkgsRelease;
          };
          claude-code-nodejs22 = shared.devShell-for {
            package = packages.claude-code-nodejs22;
            python = pkgs.python3;
            inherit pkgs nixpkgsRelease;
          };
          claude-code-nodejs24 = shared.devShell-for {
            package = packages.claude-code-nodejs24;
            python = pkgs.python3;
            inherit pkgs nixpkgsRelease;
          };
        };
        packages = rec {
          default = claude-code-nodejs24;
          claude-code-nodejs18 = claude-code-for { nodejs = pkgs.nodejs_18; };
          claude-code-nodejs20 = claude-code-for { nodejs = pkgs.nodejs_20; };
          claude-code-nodejs22 = claude-code-for { nodejs = pkgs.nodejs_22; };
          claude-code-nodejs24 = claude-code-for { nodejs = pkgs.nodejs_24; };
        };
      });
}
