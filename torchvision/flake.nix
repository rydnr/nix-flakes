# torchvision/flake.nix
#
# This file packages PyTorchVision as a Nix flake.
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
  description = "PyTorchVision from nixpkgs.";

  inputs = rec {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    nixos.url = "github:NixOS/nixpkgs/24.05";
    rydnr-nix-flakes-pytorch = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      url = "github:rydnr/nix-flakes/pytorch-2.3.0.0?dir=pytorch";
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
      nixpkgsRelease = "nixos-24.05";
      shared = import ../shared.nix;
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
        rydnr-nix-flakes-torchvision-for =
          { pkgs, python, rydnr-nix-flakes-pytorch }:
          let
            inherit (rydnr-nix-flakes-pytorch)
              cudaCapabilities cudaPackages cudaSupport;
            inherit (cudaPackages) backendStdenv;
            boolToString = b: if b then "true" else "false";
            pname = "torchvision";
            version = "0.16.2";
          in python.pkgs.buildPythonPackage {
            inherit pname version;

            src = pkgs.fetchFromGitHub {
              owner = "pytorch";
              repo = "vision";
              rev = "refs/tags/v${version}";
              hash = "sha256-fSFoMZbF0bYqonvgoNAE8ZzwCsjhCdVo2BJ0pOC2zd0=";
            };

            nativeBuildInputs = with pkgs;
              [ libpng ninja which ] ++ pkgs.lib.optionals cudaSupport [
                cudaPackages.cuda_nvcc
                cudaPackages.cudatoolkit
              ];

            buildInputs = with pkgs;
              [ libjpeg_turbo libpng ] ++ pkgs.lib.optionals cudaSupport [
                cudaPackages.cuda_nvcc
                cudaPackages.cudatoolkit
              ];

            propagatedBuildInputs = with python.pkgs; [
              numpy
              pillow
              rydnr-nix-flakes-pytorch
              scipy
            ];

            preConfigure = ''
              export TORCHVISION_INCLUDE="${pkgs.libjpeg_turbo.dev}/include/"
              export TORCHVISION_LIBRARY="${pkgs.libjpeg_turbo}/lib/"
            ''
              # NOTE: We essentially override the compilers provided by stdenv because we don't have a hook
              #   for cudaPackages to swap in compilers supported by NVCC.
              + pkgs.lib.optionalString cudaSupport ''
                export CC=${backendStdenv.cc}/bin/cc
                export CXX=${backendStdenv.cc}/bin/c++
                export TORCH_CUDA_ARCH_LIST="${
                  pkgs.lib.concatStringsSep ";" cudaCapabilities
                }"
                export FORCE_CUDA=1
              '';

            # tries to download many datasets for tests
            doCheck = false;

            pythonImportsCheck = [ "torchvision" ];
            checkPhase = ''
              HOME=$TMPDIR py.test test --ignore=test/test_datasets_download.py
            '';

            nativeCheckInputs = [ pytest ];

            meta = with pkgs.lib; {
              description = "PyTorch vision library";
              homepage = "https://pytorch.org/";
              license = licenses.bsd3;
              platforms = with platforms;
                linux ++ pkgs.lib.optionals (!cudaSupport) darwin;
              maintainers = with maintainers; [ ericsagnes ];
            };
          };
      in rec {
        defaultPackage = packages.default;
        devShells = rec {
          default = rydnr-nix-flakes-torchvision-python312;
          rydnr-nix-flakes-torchvision-python39 = shared.devShell-for {
            package = packages.rydnr-nix-flakes-torchvision-python39;
            pkgs = pkgsNonCuda;
            python = pkgsNonCuda.python39;
            inherit nixpkgsRelease;
          };
          rydnr-nix-flakes-torchvision-python39-cuda = shared.devShell-for {
            package = packages.rydnr-nix-flakes-torchvision-python39-cuda;
            pkgs = pkgsCuda;
            python = pkgsCuda.python39;
            inherit nixpkgsRelease;
          };
          rydnr-nix-flakes-torchvision-python310 = shared.devShell-for {
            package = packages.rydnr-nix-flakes-torchvision-python310;
            pkgs = pkgsNonCuda;
            python = pkgsNonCuda.python310;
            inherit nixpkgsRelease;
          };
          rydnr-nix-flakes-torchvision-python310-cuda = shared.devShell-for {
            package = packages.rydnr-nix-flakes-torchvision-python310-cuda;
            pkgs = pkgsCuda;
            python = pkgsCuda.python310;
            inherit nixpkgsRelease;
          };
          rydnr-nix-flakes-torchvision-python311 = shared.devShell-for {
            package = packages.rydnr-nix-flakes-torchvision-python311;
            pkgs = pkgsNonCuda;
            python = pkgsNonCuda.python311;
            inherit nixpkgsRelease;
          };
          rydnr-nix-flakes-torchvision-python311-cuda = shared.devShell-for {
            package = packages.rydnr-nix-flakes-torchvision-python311-cuda;
            pkgs = pkgsCuda;
            python = pkgsCuda.python311;
            inherit nixpkgsRelease;
          };
          rydnr-nix-flakes-torchvision-python312 = shared.devShell-for {
            package = packages.rydnr-nix-flakes-torchvision-python312;
            pkgs = pkgsNonCuda;
            python = pkgsNonCuda.python312;
            inherit nixpkgsRelease;
          };
          rydnr-nix-flakes-torchvision-python312-cuda = shared.devShell-for {
            package = packages.rydnr-nix-flakes-torchvision-python312-cuda;
            pkgs = pkgsCuda;
            python = pkgsCuda.python312;
            inherit nixpkgsRelease;
          };
          rydnr-nix-flakes-torchvision-python313 = shared.devShell-for {
            package = packages.rydnr-nix-flakes-torchvision-python313;
            pkgs = pkgsNonCuda;
            python = pkgsNonCuda.python313;
            inherit nixpkgsRelease;
          };
          rydnr-nix-flakes-torchvision-python313-cuda = shared.devShell-for {
            package = packages.rydnr-nix-flakes-torchvision-python313-cuda;
            pkgs = pkgsCuda;
            python = pkgsCuda.python313;
            inherit nixpkgsRelease;
          };
        };
        packages = rec {
          default = rydnr-nix-flakes-torchvision-python310-cuda;
          rydnr-nix-flakes-torchvision-python38 =
            rydnr-nix-flakes-torchvision-for {
              pkgs = pkgsNonCuda;
              python = pkgsNonCuda.python38;
              rydnr-nix-flakes-pytorch =
                rydnr-nix-flakes-pytorch.packages.${system}.rydnr-nix-flakes-pytorch-python38;
            };
          rydnr-nix-flakes-torchvision-python38-cuda =
            rydnr-nix-flakes-torchvision-for {
              pkgs = pkgsCuda;
              python = pkgsCuda.python38;
              rydnr-nix-flakes-pytorch =
                rydnr-nix-flakes-pytorch.packages.${system}.rydnr-nix-flakes-pytorch-python38-cuda;
            };
          rydnr-nix-flakes-torchvision-python39 =
            rydnr-nix-flakes-torchvision-for {
              pkgs = pkgsNonCuda;
              python = pkgsNonCuda.python39;
              rydnr-nix-flakes-pytorch =
                rydnr-nix-flakes-pytorch.packages.${system}.rydnr-nix-flakes-pytorch-python39;
            };
          rydnr-nix-flakes-torchvision-python39-cuda =
            rydnr-nix-flakes-torchvision-for {
              pkgs = pkgsCuda;
              python = pkgsCuda.python39;
              rydnr-nix-flakes-pytorch =
                rydnr-nix-flakes-pytorch.packages.${system}.rydnr-nix-flakes-pytorch-python39-cuda;
            };
          rydnr-nix-flakes-torchvision-python310 =
            rydnr-nix-flakes-torchvision-for {
              pkgs = pkgsNonCuda;
              python = pkgsNonCuda.python310;
              rydnr-nix-flakes-pytorch =
                rydnr-nix-flakes-pytorch.packages.${system}.rydnr-nix-flakes-pytorch-python310;
            };
          rydnr-nix-flakes-torchvision-python310-cuda =
            rydnr-nix-flakes-torchvision-for {
              pkgs = pkgsCuda;
              python = pkgsCuda.python310;
              rydnr-nix-flakes-pytorch =
                rydnr-nix-flakes-pytorch.packages.${system}.rydnr-nix-flakes-pytorch-python310-cuda;
            };
        };
      });
}
