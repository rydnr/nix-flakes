# readability/flake.nix
#
# This file packages readability as a Nix flake.
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
  description =
    "Nix flake for readability";

  inputs = rec {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    flit = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:rydnr/nix-flakes/flit-3.9.0.3?dir=flit";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/24.05";
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
        owner = "andreasvc";
        repo = "readability";
        version = "0.3.1";
        pname = repo;
        description =
          "An implementation of traditional readability measures based on simple surface characteristics.";
        homepage = "https://github.com/${owner}/${repo}";
        maintainers = [ "dvcoolarun" ];
        nixpkgsVersion = builtins.readFile "${nixpkgs}/.version";
        nixpkgsRelease =
          builtins.replaceStrings [ "\n" ] [ "" ] "nixpkgs-${nixpkgsVersion}";
        pkgs = import nixpkgs { inherit system; };
        shared = import ../shared.nix;
        readability-for = { flit, python }:
          python.pkgs.buildPythonPackage rec {
            inherit pname version;

            src = pkgs.fetchPypi {
              inherit pname version;
              sha256 = "sha256-+QMN+LwxqtRbr/qaLZzh/dgFGDPltb2jAn3zL97AD60=";
            };
            format = "setuptools";

            doCheck = false;

            nativeBuildInputs = with python.pkgs; [ setuptools ];

            meta = with pkgs.lib; {
              license = licenses.asl20;
              inherit description homepage maintainers;
            };
          };
      in rec {
        defaultPackage = packages.default;
        devShells = {
          default = devShells.readability-python312;
          readability-python39 = shared.devShell-for {
            package = packages.readability-python39;
            python = pkgs.python39;
            inherit pkgs nixpkgsRelease;
          };
          readability-python310 = shared.devShell-for {
            package = packages.readability-python310;
            python = pkgs.python310;
            inherit pkgs nixpkgsRelease;
          };
          readability-python311 = shared.devShell-for {
            package = packages.readability-python311;
            python = pkgs.python311;
            inherit pkgs nixpkgsRelease;
          };
          readability-python312 = shared.devShell-for {
            package = packages.readability-python312;
            python = pkgs.python312;
            inherit pkgs nixpkgsRelease;
          };
          readability-python313 = shared.devShell-for {
            package = packages.readability-python313;
            python = pkgs.python313;
            inherit pkgs nixpkgsRelease;
          };
        };
        packages = rec {
          default = readability-python312;
          readability-python39 = readability-for {
            flit = flit.packages.${system}.flit-python39;
            python = pkgs.python39;
          };
          readability-python310 = readability-for {
            flit = flit.packages.${system}.flit-python310;
            python = pkgs.python310;
          };
          readability-python311 = readability-for {
            flit = flit.packages.${system}.flit-python311;
            python = pkgs.python311;
          };
          readability-python312 = readability-for {
            flit = flit.packages.${system}.flit-python312;
            python = pkgs.python312;
          };
          readability-python313 = readability-for {
            flit = flit.packages.${system}.flit-python313;
            python = pkgs.python313;
          };
        };
      });
}
