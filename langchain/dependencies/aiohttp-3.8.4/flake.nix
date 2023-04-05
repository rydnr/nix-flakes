{
  description = "A Nix flake for aiohttp 3.8.4 Python package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python3;
        pythonPackages = python.pkgs;
      in rec {
        packages.aiohttp-3_8_4 = (import ./aiohttp-3.8.4.nix) {
          inherit (pythonPackages)
            buildPythonPackage fetchPypi pythonOlder
            # install_requires
            attrs charset-normalizer multidict async-timeout yarl frozenlist
            aiosignal aiodns brotli cchardet asynctest typing-extensions
            idna-ssl
            # tests_require
            async_generator freezegun gunicorn pytest-mock pytestCheckHook
            re-assert trustme;

          inherit (pkgs) lib stdenv;
        };
        packages.default = packages.aiohttp-3_8_4;
        devShell = pkgs.mkShell {
          buildInputs = with pkgs.python3Packages; [ packages.aiohttp-3_8_4 ];
        };
      });
}
