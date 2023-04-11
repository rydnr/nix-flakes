{
  description = "A Nix flake for Pmxbot 1122.14.2 Python package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python3;
        pythonPackages = python.pkgs;
      in rec {
        packages = {
          pmxbot-1122_14_2 = (import ./pmxbot-1122.14.2.nix) {
            inherit (pythonPackages) buildPythonApplication;
            inherit (pkgs) fetchFromGitHub lib stdenv;
          };
          pmxbot = packages.pmxbot-1122_14_2;
          default = packages.pmxbot;
          meta = with lib; {
            description = "pmxbot is bot for IRC and Slack written in Python.";
            license = licenses.mit;
            homepage = "https://github.com/pmxbot/pmxbot";
            maintainers = with maintainers; [ ];
          };
        };
        devShell = pkgs.mkShell {
          buildInputs = with pkgs.python3Packages; [ packages.default ];
        };
        shell = flake-utils.lib.mkShell {
          packages = system: [ self.packages.${system}.default ];
        };
      });
}
