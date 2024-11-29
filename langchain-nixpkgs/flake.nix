# langchain-nixpkgs/flake.nix
#
# This file packages Langchain as a Nix flake.
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
  description = "Nix flake for langchain in nixpkgs";

  inputs = rec {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    nixos.url = "github:NixOS/nixpkgs/24.05";
  };
  outputs = inputs:
    with inputs;
    let
      defaultSystems = flake-utils.lib.defaultSystems;
      supportedSystems = if builtins.elem "armv6l-linux" defaultSystems then
        defaultSystems
      else
        defaultSystems ++ [ "armv6l-linux" ];
      nixpkgsRelease = "nixos-24.05";
      shared = import ../shared.nix;
    in flake-utils.lib.eachSystem supportedSystems (system:
      let
        langchainNonCudaOverlay = final: prev: {
          llama-cpp = prev.llama-cpp.overrideAttrs (oldAttrs: {
            cudaSupport = true;
            nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ prev.git ];
          });
        };
        langchainCudaOverlay = final: prev: {
          llama-cpp = prev.llama-cpp.overrideAttrs (oldAttrs: {
            cudaSupport = true;
            nativeBuildInputs = oldAttrs.nativeBuildInputs
              ++ [ prev.cudatoolkit prev.git ];
          });
        };
        pkgsNonCuda = import nixos {
          overlays = [ langchainNonCudaOverlay ];
          inherit system;
        };
        pkgsCuda = import nixos {
          config = {
            allowUnfree = true;
            allowUnfreePredicate = pkg:
              builtins.elem (pkgs.lib.getName pkg) [ "cudatoolkit" ];
          };
          overlays = [ langchainCudaOverlay ];
          inherit system;
        };
      in rec {
        defaultPackage = packages.default;
        devShells = rec {
          default = rydnr-nix-flakes-langchain-python312;
          rydnr-nix-flakes-langchain-python39 = shared.devShell-for {
            package = packages.rydnr-nix-flakes-langchain-python39;
            pkgs = pkgsNonCuda;
            python = pkgsNonCuda.python39;
            inherit nixpkgsRelease;
          };
          rydnr-nix-flakes-langchain-python39-cuda = shared.devShell-for {
            package = packages.rydnr-nix-flakes-langchain-python39-cuda;
            pkgs = pkgsCuda;
            python = pkgsCuda.python39;
            inherit nixpkgsRelease;
          };
          rydnr-nix-flakes-langchain-python310 = shared.devShell-for {
            package = packages.rydnr-nix-flakes-langchain-python310;
            pkgs = pkgsNonCuda;
            python = pkgsNonCuda.python310;
            inherit nixpkgsRelease;
          };
          rydnr-nix-flakes-langchain-python310-cuda = shared.devShell-for {
            package = packages.rydnr-nix-flakes-langchain-python310-cuda;
            pkgs = pkgsCuda;
            python = pkgsCuda.python310;
            inherit nixpkgsRelease;
          };
          rydnr-nix-flakes-langchain-python311 = shared.devShell-for {
            package = packages.rydnr-nix-flakes-langchain-python311;
            pkgs = pkgsNonCuda;
            python = pkgsNonCuda.python311;
            inherit nixpkgsRelease;
          };
          rydnr-nix-flakes-langchain-python311-cuda = shared.devShell-for {
            package = packages.rydnr-nix-flakes-langchain-python311-cuda;
            pkgs = pkgsCuda;
            python = pkgsCuda.python311;
            inherit nixpkgsRelease;
          };
          rydnr-nix-flakes-langchain-python312 = shared.devShell-for {
            package = packages.rydnr-nix-flakes-langchain-python312;
            pkgs = pkgsNonCuda;
            python = pkgsNonCuda.python312;
            inherit nixpkgsRelease;
          };
          rydnr-nix-flakes-langchain-python312-cuda = shared.devShell-for {
            package = packages.rydnr-nix-flakes-langchain-python312-cuda;
            pkgs = pkgsCuda;
            python = pkgsCuda.python312;
            inherit nixpkgsRelease;
          };
          rydnr-nix-flakes-langchain-python313 = shared.devShell-for {
            package = packages.rydnr-nix-flakes-langchain-python313;
            pkgs = pkgsNonCuda;
            python = pkgsNonCuda.python313;
            inherit nixpkgsRelease;
          };
          rydnr-nix-flakes-langchain-python313-cuda = shared.devShell-for {
            package = packages.rydnr-nix-flakes-langchain-python313-cuda;
            pkgs = pkgsCuda;
            python = pkgsCuda.python313;
            inherit nixpkgsRelease;
          };
        };
        packages = rec {
          default = rydnr-nix-flakes-langchain-python312-cuda;
          rydnr-nix-flakes-langchain-python39 =
            pkgsNonCuda.python39.pkgs.langchain;
          rydnr-nix-flakes-langchain-python39-cuda =
            pkgsCuda.python39.pkgs.langchain;
          rydnr-nix-flakes-langchain-python310 =
            pkgsNonCuda.python310.pkgs.langchain;
          rydnr-nix-flakes-langchain-python310-cuda =
            pkgsCuda.python310.pkgs.langchain;
          rydnr-nix-flakes-langchain-python311 =
            pkgsNonCuda.python311.pkgs.langchain;
          rydnr-nix-flakes-langchain-python311-cuda =
            pkgsCuda.python311.pkgs.langchain;
          rydnr-nix-flakes-langchain-python312 =
            pkgsNonCuda.python312.pkgs.langchain;
          rydnr-nix-flakes-langchain-python312-cuda =
            pkgsCuda.python312.pkgs.langchain;
          rydnr-nix-flakes-langchain-python313 =
            pkgsNonCuda.python313.pkgs.langchain;
          rydnr-nix-flakes-langchain-python313-cuda =
            pkgsCuda.python313.pkgs.langchain;
        };
      });
}
