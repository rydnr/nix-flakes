{
  description = "A Nix flake for opensearch-py 2.2.0 Python package";

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
          opensearch-py-2.2.0 = (import ./opensearch-py-2.2.0.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi
             inherit (pkgs) lib;
          };
          opensearch-py = packages.opensearch-py-2.2.0;
          default = packages.opensearch-py;
          meta = with lib; {
            description = ''
[![Release](https://github.com/opensearch-project/opensearch-py/actions/workflows/unified-release.yml/badge.svg)](https://github.com/opensearch-project/opensearch-py/actions/workflows/unified-release.yml)
[![CI](https://github.com/opensearch-project/opensearch-py/actions/workflows/ci.yml/badge.svg)](https://github.com/opensearch-project/opensearch-py/actions/workflows/ci.yml)
[![Integration](https://github.com/opensearch-project/opensearch-py/actions/workflows/integration.yml/badge.svg)](https://github.com/opensearch-project/opensearch-py/actions/workflows/integration.yml)
[![Chat](https://img.shields.io/badge/chat-on%20forums-blue)](https://discuss.opendistrocommunity.dev/c/clients/)
![PRs welcome!](https://img.shields.io/badge/PRs-welcome!-success)

![OpenSearch logo](https://github.com/opensearch-project/opensearch-py/raw/main/OpenSearch.svg)

OpenSearch Python Client

- [Welcome!](https://github.com/opensearch-project/opensearch-py#welcome)
- [User Guide](https://github.com/opensearch-project/opensearch-py#user-guide)
- [API Doc](https://opensearch-project.github.io/opensearch-py/)
- [Compatibility with OpenSearch](https://github.com/opensearch-project/opensearch-py#compatibility-with-opensearch)
- [Project Resources](https://github.com/opensearch-project/opensearch-py#project-resources)
- [Code of Conduct](https://github.com/opensearch-project/opensearch-py#code-of-conduct)
- [License](https://github.com/opensearch-project/opensearch-py#license)
- [Copyright](https://github.com/opensearch-project/opensearch-py#copyright)

## Welcome!

**opensearch-py** is [a community-driven, open source fork](https://aws.amazon.com/blogs/opensource/introducing-opensearch/)
of elasticsearch-py licensed under the [Apache v2.0 License](https://github.com/opensearch-project/opensearch-py/blob/main/LICENSE.txt). 
For more information, see [opensearch.org](https://opensearch.org/) and the [API Doc](https://opensearch-project.github.io/opensearch-py/).

## User Guide

To get started with the OpenSearch Python Client, see [User Guide](https://github.com/opensearch-project/opensearch-py/blob/main/USER_GUIDE.md).

## Compatibility with OpenSearch

See [Compatibility](https://github.com/opensearch-project/opensearch-py/blob/main/COMPATIBILITY.md).

## Project Resources

* [Project Website](https://opensearch.org/)
* [Downloads](https://opensearch.org/downloads.html)
* [Documentation](https://opensearch.org/docs/latest/clients/python/)
* Need help? Try [Forums](https://discuss.opendistrocommunity.dev/)
* [Project Principles](https://opensearch.org/#principles)
* [Contributing to OpenSearch](https://github.com/opensearch-project/opensearch-py/blob/main/CONTRIBUTING.md)
* [Maintainer Responsibilities](https://github.com/opensearch-project/opensearch-py/blob/main/MAINTAINERS.md)
* [Release Management](https://github.com/opensearch-project/opensearch-py/blob/main/RELEASING.md)
* [Admin Responsibilities](https://github.com/opensearch-project/opensearch-py/blob/main/ADMINS.md)
* [Security](https://github.com/opensearch-project/opensearch-py/blob/main/SECURITY.md)

## Code of Conduct

This project has adopted the 
[Amazon Open Source Code of Conduct](https://github.com/opensearch-project/opensearch-py/blob/main/CODE_OF_CONDUCT.md).
For more information see the [Code of Conduct FAQ](https://aws.github.io/code-of-conduct-faq), or contact 
[opensource-codeofconduct@amazon.com](mailto:opensource-codeofconduct@amazon.com) with any additional questions or comments.

## License

This project is licensed under the
[Apache v2.0 License](https://github.com/opensearch-project/opensearch-py/blob/main/LICENSE.txt).

## Copyright

Copyright OpenSearch Contributors. See 
[NOTICE](https://github.com/opensearch-project/opensearch-py/blob/main/NOTICE.txt) for details.

'';
            license = licenses.asl20;
            homepage = "None";
            maintainers = with maintainers; [ ];
          };
        };
        defaultPackage = packages.default;
        devShell = pkgs.mkShell {
          buildInputs = with pkgs.python3Packages; [ packages.default ];
        };
        shell = flake-utils.lib.mkShell {
          packages = system: [ self.packages.${system}.default ];
        };
      });
}
