{
  description = "A Nix flake for linkchecker 10.2.1 Python package";

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
          linkchecker-10.2.1 = (import ./linkchecker-10.2.1.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi
             inherit (pkgs) lib;
          };
          linkchecker = packages.linkchecker-10.2.1;
          default = packages.linkchecker;
          meta = with lib; {
            description = ''
LinkChecker
============

|Build Status|_ |License|_

.. |Build Status| image:: https://github.com/linkchecker/linkchecker/actions/workflows/build.yml/badge.svg?branch=master
.. _Build Status: https://github.com/linkchecker/linkchecker/actions/workflows/build.yml
.. |License| image:: https://img.shields.io/badge/license-GPL2-d49a6a.svg
.. _License: https://opensource.org/licenses/GPL-2.0

Check for broken links in web sites.

Features
---------

- recursive and multithreaded checking and site crawling
- output in colored or normal text, HTML, SQL, CSV, XML or a sitemap graph in different formats
- HTTP/1.1, HTTPS, FTP, mailto:, news:, nntp:, Telnet and local file links support
- restrict link checking with regular expression filters for URLs
- proxy support
- username/password authorization for HTTP, FTP and Telnet
- honors robots.txt exclusion protocol
- Cookie support
- HTML5 support
- a command line and web interface
- various check plugins available

Installation
-------------

Python 3.7 or later is needed. Using pip to install LinkChecker:

``pip3 install linkchecker``

The version in the pip repository may be old, to find out how to get the latest
code, plus platform-specific information and other advice see `doc/install.txt`_
in the source code archive.

.. _doc/install.txt: https://linkchecker.github.io/linkchecker/install.html


Usage
------
Execute ``linkchecker https://www.example.com``.
For other options see ``linkchecker --help``, and for more information the
manual pages `linkchecker(1)`_ and `linkcheckerrc(5)`_.

.. _linkchecker(1): https://linkchecker.github.io/linkchecker/man/linkchecker.html

.. _linkcheckerrc(5): https://linkchecker.github.io/linkchecker/man/linkcheckerrc.html

Docker usage
-------------

If you do not want to install any additional libraries/dependencies you can use
the Docker image which is published on GitHub Packages.

Example for external web site check::

  docker run --rm -it -u $(id -u):$(id -g) ghcr.io/linkchecker/linkchecker:latest --verbose https://www.example.com

Local HTML file check::

  docker run --rm -it -u $(id -u):$(id -g) -v "$PWD":/mnt ghcr.io/linkchecker/linkchecker:latest --verbose index.html

In addition to the rolling latest image, uniquely tagged images can also be found
on the `packages`_ page.

.. _packages: https://github.com/linkchecker/linkchecker/pkgs/container/linkchecker

'';
            license = licenses.mit;
            homepage = "https://github.com/linkchecker/linkchecker";
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
