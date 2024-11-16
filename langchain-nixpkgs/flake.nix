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
  description = "Langchain from nixpkgs.";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/24.05";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
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
        packages = rec {
          default = rydnr-nix-flakes-langchain-python312-cuda;
          rydnr-nix-flakes-langchain-python38 =
            pkgsNonCuda.python38.pkgs.langchain;
          rydnr-nix-flakes-langchain-python38-cuda =
            pkgsCuda.python38.pkgs.langchain;
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
        };
      });
}
