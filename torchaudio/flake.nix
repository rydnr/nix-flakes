# torchaudio/flake.nix
#
# This file packages PyTorchAudio as a Nix flake.
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
  description = "PyTorchAudio from nixpkgs.";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/23.05";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    rydnr-nix-flakes-pytorch = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      url = "github:rydnr/nix-flakes/pytorch-2.0.1-1?dir=pytorch";
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
        pythonCudaOverlay = final: prev: {
          python = prev.python.override {
            packageOverrides = pySelf: pySuper: {
              pytorch = rydnr-nix-flakes-pytorch;
            };
          };
        };
        pythonNonCudaOverlay = final: prev: {
          python = prev.python.override {
            packageOverrides = pySelf: pySuper: rec {
              pytorch = rydnr-nix-flakes-pytorch-nocuda;
            };
          };
        };
        pkgsNonCuda = import nixos {
          overlays = [ pythonNonCudaOverlay ];
          inherit system;
        };
        pkgsCuda = import nixos {
          config = {
            allowUnfree = true;
            allowUnfreePredicate = pkg:
              builtins.elem (pkgs.lib.getName pkg) [ "cudatoolkit" ];
          };
          overlays = [ pythonCudaOverlay ];
          inherit system;
        };
      in rec {
        defaultPackage = packages.default;
        packages = rec {
          default = rydnr-nix-flakes-torchaudio-python310-cuda;
          rydnr-nix-flakes-torchaudio-python38 =
            pkgsNonCuda.python38.pkgs.torchaudio;
          rydnr-nix-flakes-torchaudio-python38-cuda =
            pkgsCuda.python38.pkgs.torchaudio;
          rydnr-nix-flakes-torchaudio-python39 =
            pkgsNonCuda.python39.pkgs.torchaudio;
          rydnr-nix-flakes-torchaudio-python39-cuda =
            pkgsCuda.python39.pkgs.torchaudio;
          rydnr-nix-flakes-torchaudio-python310 =
            pkgsNonCuda.python310.pkgs.torchaudio;
          rydnr-nix-flakes-torchaudio-python310-cuda =
            pkgsCuda.python310.pkgs.torchaudio;
        };
      });
}
