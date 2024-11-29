# beautifulsoup4/flake.nix
#
# This file packages Beautifulsoup4 as a Nix flake.
#
# Copyright (C) 2024-today rydnr's rydnr/nix-flakes
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
{
  description = "Nix flake for beautifulsoup4";
  inputs = rec {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    nixos.url = "github:NixOS/nixpkgs/24.05";
    pythoneda-shared-pythonlang-banner = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      url = "github:pythoneda-shared-pythonlang-def/banner/0.0.61";
    };
    pythoneda-shared-pythonlang-domain = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      url = "github:pythoneda-shared-pythonlang-def/domain/0.0.64";
    };
  };
  outputs = inputs:
    with inputs;
    let
      defaultSystems = flake-utils.lib.defaultSystems;
      supportedSystems = if builtins.elem "armv6l-linux" defaultSystems then
        defaultSystems
      else
        defaultSystems ++ [ "armv6l-linux" ];
    in flake-utils.lib.eachSystem supportedSystems (system:
      let
        version = "4.12.3";
        sha256 = "sha256-dOPRko7cBw0hdIGFxG4/szSQ8i9So63e6a7g9Pd4EFE=";
        org = "(ext)";
        repo = "(ext)";
        pname = "beautifulsoup4";
        pkgs = import nixos { inherit system; };
        description = "HTML and XML parser";
        license = pkgs.lib.licenses.mit;
        homepage = "https://www.crummy.com/software/BeautifulSoup/bs4/";
        maintainers = with maintainers; [ domenkozar ];
        archRole = "B";
        space = "D";
        layer = "D";
        nixosVersion = builtins.readFile "${nixos}/.version";
        nixpkgsRelease =
          builtins.replaceStrings [ "\n" ] [ "" ] "nixos-${nixosVersion}";
        shared = import "${pythoneda-shared-pythonlang-banner}/nix/shared.nix";
        beautifulsoup4-for = { python }:
          python.pkgs.buildPythonPackage rec {

            inherit pname version;
            format = "pyproject";
            outputs = [ "out" "doc" ];
            src = python.pkgs.fetchPypi { inherit pname version sha256; };

            nativeBuildInputs = with python.pkgs; [ hatchling sphinxHook ];
            checkInputs = with python.pkgs; [ pytest ];
            checkPhase = ''
              py.test $out/${python.sitePackages}/bs4/tests
            '';

            propagatedBuildInputs = with python.pkgs; [ chardet soupsieve ];

            passthru.optional-dependencies = with python.pkgs; {
              html5lib = [ html5lib ];
              lxml = [ lxml ];
            };

            nativeCheckInputs = [ python.pkgs.pytestCheckHook ]
              ++ pkgs.lib.flatten
              (builtins.attrValues passthru.optional-dependencies);

            pythonImportsCheck = [ "bs4" ];

            passthru.tests = {
              inherit html-sanitizer markdownify mechanicalsoup nbconvert
                subliminal wagtail;
            };
            meta = with pkgs.lib; {
              description = "HTML and XML parser";
              license = licenses.mit;
              maintainers = with maintainers; [ domenkozar ];
            };
          };
      in rec {
        defaultPackage = packages.default;
        devShells = rec {
          default = beautifulsoup4-default;
          beautifulsoup4-default = beautifulsoup4-python312;
          beautifulsoup4-python39 = shared.devShell-for {
            banner = "${
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python39
              }/bin/banner.sh";
            extra-namespaces = "";
            nixpkgs-release = nixpkgsRelease;
            package = packages.beautifulsoup4-python39;
            python = pkgs.python39;
            pythoneda-shared-pythonlang-banner =
              pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python39;
            pythoneda-shared-pythonlang-domain =
              pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python39;
            inherit archRole layer org pkgs repo space;
          };
          beautifulsoup4-python310 = shared.devShell-for {
            banner = "${
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python310
              }/bin/banner.sh";
            extra-namespaces = "";
            nixpkgs-release = nixpkgsRelease;
            package = packages.beautifulsoup4-python310;
            python = pkgs.python310;
            pythoneda-shared-pythonlang-banner =
              pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python310;
            pythoneda-shared-pythonlang-domain =
              pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python310;
            inherit archRole layer org pkgs repo space;
          };
          beautifulsoup4-python311 = shared.devShell-for {
            banner = "${
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python311
              }/bin/banner.sh";
            extra-namespaces = "";
            nixpkgs-release = nixpkgsRelease;
            package = packages.beautifulsoup4-python311;
            python = pkgs.python311;
            pythoneda-shared-pythonlang-banner =
              pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python311;
            pythoneda-shared-pythonlang-domain =
              pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python311;
            inherit archRole layer org pkgs repo space;
          };
          beautifulsoup4-python312 = shared.devShell-for {
            banner = "${
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python312
              }/bin/banner.sh";
            extra-namespaces = "";
            nixpkgs-release = nixpkgsRelease;
            package = packages.beautifulsoup4-python312;
            python = pkgs.python312;
            pythoneda-shared-pythonlang-banner =
              pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python312;
            pythoneda-shared-pythonlang-domain =
              pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python312;
            inherit archRole layer org pkgs repo space;
          };
          beautifulsoup4-python313 = shared.devShell-for {
            banner = "${
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python313
              }/bin/banner.sh";
            extra-namespaces = "";
            nixpkgs-release = nixpkgsRelease;
            package = packages.beautifulsoup4-python313;
            python = pkgs.python313;
            pythoneda-shared-pythonlang-banner =
              pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python313;
            pythoneda-shared-pythonlang-domain =
              pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python313;
            inherit archRole layer org pkgs repo space;
          };
        };
        packages = rec {
          default = beautifulsoup4-default;
          beautifulsoup4-default = beautifulsoup4-python312;
          beautifulsoup4-python39 =
            beautifulsoup4-for { python = pkgs.python39; };
          beautifulsoup4-python310 =
            beautifulsoup4-for { python = pkgs.python310; };
          beautifulsoup4-python311 =
            beautifulsoup4-for { python = pkgs.python311; };
          beautifulsoup4-python312 =
            beautifulsoup4-for { python = pkgs.python312; };
          beautifulsoup4-python313 =
            beautifulsoup4-for { python = pkgs.python313; };
        };
      });
}
