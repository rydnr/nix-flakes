# torch/flake.nix
#
# This file packages Ollama as a Nix flake.
#
# Copyright (C) 2023-today rydnr's rydnr/nix-flakes
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
  description = "Ollama from nixpkgs.";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/nixos-unstable";
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
        ollamaNonCudaOverlay = final: prev: {
          llama-cpp = prev.llama-cpp.overrideAttrs (oldAttrs: {
            cudaSupport = true;
            nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ prev.git ];
          });
        };
        ollamaCudaOverlay = final: prev: {
          llama-cpp = prev.llama-cpp.overrideAttrs (oldAttrs: {
            cudaSupport = true;
            nativeBuildInputs = oldAttrs.nativeBuildInputs
              ++ [ prev.cudatoolkit prev.git ];
          });
        };
        pkgsNonCuda = import nixos {
          overlays = [ ollamaNonCudaOverlay ];
          inherit system;
        };
        pkgsCuda = import nixos {
          config = {
            allowUnfree = true;
            allowUnfreePredicate = pkg:
              builtins.elem (pkgs.lib.getName pkg) [ "cudatoolkit" ];
          };
          overlays = [ ollamaCudaOverlay ];
          inherit system;
        };
      in rec {
        defaultPackage = packages.default;
        packages = rec {
          default = rydnr-nix-flakes-ollama-cuda;
          rydnr-nix-flakes-ollama-cuda = pkgsCuda.ollama;
          rydnr-nix-flakes-ollama = pkgsNonCuda.ollama;
        };
      });
}
