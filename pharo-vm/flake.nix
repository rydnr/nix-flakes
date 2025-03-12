{
  description = "Flake for Pharo-VM";

  inputs = rec {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.11";
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        org = "pharo-project";
        repo = "pharo-vm";
        pname = "${repo}";
        pkgs = import nixpkgs { inherit system; };
        description = "Pharo VM";
        license = pkgs.lib.licenses.mit;
        homepage = "https://pharo.org";
        maintainers = with pkgs.lib.maintainers; [ ehmry ];
        nixpkgsVersion = builtins.readFile "${nixpkgs}/.version";
        nixpkgsRelease =
          builtins.replaceStrings [ "\n" ] [ "" ] "nixpkgs-${nixpkgsVersion}";
        shared = import ../shared.nix;
        pharo-vm-for = { version, sha256, commit, c-sources-url, c-sources-zip, c-sources-sha256, headless-bin-url, headless-bin-zip, headless-bin-sha256, bootstrap-image-url, bootstrap-image-zip, bootstrap-image-sha256 }:
          let
            c-sources = pkgs.fetchurl {
              url = c-sources-url;
              sha256 = c-sources-sha256;
            };
            headless-bin = pkgs.fetchurl {
              url = headless-bin-url;
              sha256 = headless-bin-sha256;
            };
            bootstrap-image = pkgs.fetchurl {
              url = bootstrap-image-url;
              sha256 = bootstrap-image-sha256;
            };
            src = pkgs.fetchgit {
              url = "https://github.com/${org}/${repo}.git";
              rev = "v${version}";
              inherit sha256;
              fetchSubmodules = true;
            };
          in pkgs.stdenv.mkDerivation (finalAttrs: {
            inherit pname src version;

            strictDeps = true;

            buildInputs = with pkgs; [
              cairo
              freetype
              libffi
              libgit2
              libpng
              libuuid
              openssl
              pixman
              SDL2
            ];

            nativeBuildInputs = with pkgs; [
              automake
              binutils
              cmake
              graphviz
              libtool
              makeBinaryWrapper
              unzip
              wget
            ];

            preUnpack = ''
              mkdir -p tmp
              unzip -o ${c-sources} -d tmp
              mv tmp/pharo-vm repository
              rm -rf tmp
              unzip -o ${headless-bin} -d headless
              unzip -o ${bootstrap-image} -d image
            '';

            prePatch = ''
              for file in macros.cmake ../repository/macros.cmake; do
               sed -i '/download_project(PROJ /,/)$/s/^/#/' $file
              # sed -i '/file(GLOB DOWNLOADED_THIRD_PARTY_LIBRARIES/,/)$/s/^/#/' $file
              done
              # sed -i '/ExternalProject_Add(/,/)$/s/^/#/' cmake/vmmaker.cmake
              # vmmaker must be written to /build/pharo-vm/build/build/vmmaker
              mkdir -p build/build/vmmaker/src ../repository/build/build/vmmaker
              mv ../headless ../repository/build/build/vmmaker/vm
              cp ${bootstrap-image} build/build/vmmaker/src
              mv ../image build/build/vmmaker/image
              cp ${bootstrap-image} build/build/${bootstrap-image-zip}
              cp ${bootstrap-image} ../repository/build/build/${bootstrap-image-zip}
            '';

            patchPhase = ''
              runHook prePatch
              patch -p0 -d ../repository/cmake < ${./repository_cmake_vmmaker_cmake.patch}
              patch -p0 -d ./cmake < ${./pharo-vm_cmake_vmmaker_cmake.patch}
              # mkdir -p ../repository/build/build/vmmaker/vm
              patch -p0 -d ../repository/build/build/vmmaker/vm < ${./pharo.patch}

              substituteInPlace ../repository/build/build/vmmaker/vm/pharo \
                --replace-fail "/usr/bin/dirname" "${pkgs.coreutils}/bin/dirname" \
                --replace-fail "/usr/bin/ldd" "${pkgs.glibc.bin}/bin/ldd" \
                --replace-fail "/bin/fgrep" "${pkgs.gnugrep}/bin/fgrep" \
                --replace-fail 'LD_LIBRARY_PATH="' 'LD_LIBRARY_PATH="/build/repository/build/build/vmmaker/vm/lib:'

              patchelf --set-interpreter ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 ../repository/build/build/vmmaker/vm/lib/pharo
              pushd /build/repository/build/build/vmmaker/vm/lib/
              rm -f libgit2*
              ln -s ${pkgs.libgit2}/lib/libgit2.so.1.8 .
              popd

              runHook postPatch
            '';

            unusedPreConfigure = ''
              mkdir -p build/vmmaker
              touch build/vmmaker/CMakeLists.txt  # Fake it so CMake is happy
              echo "set(VMMAKER_PLACEHOLDER ON)" > build/vmmaker/CMakeLists.txt
            '';

            configurePhase = ''
              runHook preConfigure

              echo "${version}" > version.info
              echo "${version}-${commit}" >> version.info
              date '+%Y-%m-%d' >> version.info

              # sed -i "s|set_target_properties(PharoVMCore PROPERTIES LINK_INTERFACE_MULTIPLICITY 1)|set_target_properties(PharoVMCore PROPERTIES INTERFACE pharo)|g" CMakeLists.txt
              runHook postConfigure
              '';

            buildPhase = ''
              runHook preBuild

              cmake \
                --debug-output \
                -DFLAVOUR=CoInterpreter \
                -DALWAYS_INTERACTIVE=ON \
                -DGENERATE_VMMAKER=ON \
                -DGENERATE_PHARO_VM=/build/repository/build/build/vmmaker/vm/pharo \
                -DGENERATE_SOURCES=ON \
                -DVMMAKER_IMAGE=/build/repository/build/build/vmmaker/image \
                -DVMMAKER_VM=/build/repository/build/build/vmmaker/vm \
                -DBUILD_BUNDLE=ON \
                -DPHARO_DEPENDENCIES_PREFER_DOWNLOAD_BINARIES=OFF \
                -DDEPENDENCIES_FORCE_BUILD=OFF \
                -DFEATURE_LIB_GIT2=ON \
                -DFEATURE_LIB_FREETYPE2=ON \
                -DFEATURE_LIB_CAIRO=ON \
                -DFEATURE_LIB_SDL2=ON \
                -S . -B build

              cmake --build build --target generate-sources

              runHook postBuild
            '';

            installPhase = ''
              runHook preInstall

              cmake --build build --target install
              mkdir -p "$out/lib"
              mkdir "$out/bin"
              ls -lrthlia build/vm/
              cp build/vm/*.so* "$out/lib/"
              cp build/vm/pharo "$out/bin/pharo"

              runHook postInstall
             '';

            meta = {
              changelog = "https://github.com/pharo-project/pharo/releases/";
              longDescription = ''
                    Pharo's goal is to deliver a clean, innovative, free open-source
                    Smalltalk-inspired environment. By providing a stable and small core
                    system, excellent dev tools, and maintained releases, Pharo is an
                    attractive platform to build and deploy mission critical applications.
              '';
              inherit description homepage license maintainers;
              mainProgram = "pharo";
              platforms = pkgs.lib.platforms.linux;
            };
        });
      in rec {
        defaultPackage = packages.default;
        devShells = rec {
          default = pharo-vm-12;
          pharo-vm-12 = shared.devShell-for {
            package = packages.pharo-vm-12;
            python = pkgs.python3;
            inherit pkgs nixpkgsRelease;
          };
          pharo-vm-10 = shared.devShell-for {
            package = packages.pharo-vm-10;
            python = pkgs.python3;
            inherit pkgs nixpkgsRelease;
          };
          pharo-vm-9 = shared.devShell-for {
            package = packages.pharo-vm-9;
            python = pkgs.python3;
            inherit pkgs nixpkgsRelease;
          };
        };
        packages = rec {
          default = pharo-vm-12;
          pharo-vm-12 = pharo-vm-for rec {
            version = "12.0.0";
            sha256 = "sha256-0FE39wsZt8P/oimBxrPMC+bIJdLJPInavJH1R2d3mpU=";
            commit = "56a36ecab69530898a76551091f0c233769e51ae";
            c-sources-zip = "PharoVM-10.2.1-d417aeb-Linux-x86_64-c-src.zip";
            c-sources-url = "https://files.pharo.org/vm/pharo-spur64-headless/Linux-x86_64/source/${c-sources-zip}";
            c-sources-sha256 = "sha256-gbDhV1Y04GZvdlYLXEQBlnnewoXnPoGah5DmInEvKXI=";
            headless-bin-zip = "PharoVM-10.3.1-6cdb1e5-Linux-x86_64-bin.zip";
            headless-bin-url = "https://files.pharo.org/vm/pharo-spur64-headless/Linux-x86_64/${headless-bin-zip}";
            headless-bin-sha256 = "sha256-oS+VX1U//tTWabTbpvTBbowJQ0YlPY8+vR/jd+Up+lU=";
            bootstrap-image-zip = "Pharo12.0-SNAPSHOT.build.1519.sha.aa50f9c.arch.64bit.zip";
            bootstrap-image-url = "https://files.pharo.org/image/120/${bootstrap-image-zip}";
            bootstrap-image-sha256 = "sha256-sSJwYx/8DGrcsLZElWW5q/2OiKhjqJSnMg9mDAWgrx4=";
          };
          pharo-vm-10 = pharo-vm-for { version = "10.3.3"; sha256 = ""; };
          pharo-vm-9 = pharo-vm-for { version = "9.0.22"; sha256 = ""; };
        };
      });
}
