{
  description = "A Nix flake for aiohttp 3.8.4 Python package";

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
          aiohttp-3_8_4 = (import ./aiohttp-3.8.4.nix) {
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
          aiohttp = packages.aiohttp-3_8_4;
          default = packages.aiohttp;
          meta = with lib; {
            description =
              "Asynchronous HTTP Client/Server for Python and asyncio";
            license = licenses.asl20;
            homepage = "https://github.com/aio-libs/aiohttp";
            maintainers = with maintainers; [ dotlambda ];
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
