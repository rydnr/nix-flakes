{
  description = "A Nix flake for Pmxbot 1122.14.2 Python package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
    jaraco_mongodb-flake.url =
      "github:rydnr/nix-flakes?dir=langchain/dependencies/jaraco_mongodb-11.2.1";
    wordnik-py3-flake.url =
      "github:rydnr/nix-flakes?dir=langchain/dependencies/wordnik-py3-2.1.2";
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
            inherit (pythonPackages)
              beautifulsoup4 buildPythonPackage feedparser fetchPypi
              importlib-metadata importlib-resources jaraco-context
              jaraco_functools jaraco_itertools python python-dateutil pytz
              pyyaml requests setuptools;
            inherit (pkgs) lib;
            jaraco_mongodb =
              jaraco_mongodb-flake.packages.${system}.jaraco_mongodb;
            wordnik-py3 = wordnik-py3-flake.packages.${system}.wordnik-py3;
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
