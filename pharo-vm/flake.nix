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
            smacc = pkgs.fetchgit {
              url = "https://github.com/guillep/smacc";
              rev = "1b9a1ecab7870a8f2a276916b52c504af9bd992c";
              sha256 = "sha256-Nf+TrKZsh2IiHPPItYtsqPHLiQT/y7AdZyLcIkAvPzY=";
              leaveDotGit = true;
            };
            pharo-opal-simd-bytecode = pkgs.fetchgit {
              url = "https://github.com/evref-inria/pharo-opal-simd-bytecode";
              rev = "fcf681d950ace4e23055af76a1df25545452e72a";
              sha256 = "sha256-XGLbN/JdMgFOZltHhpRRZl5xpdv6GpDhsk3OnPyIKKc=";
              leaveDotGit = true;
            };
            pharo-unicorn = pkgs.fetchgit {
              url = "https://github.com/pharo-project/pharo-unicorn";
              rev = "eca62778266d19537a306bcac9bdd2881110e77f";
              sha256 = "sha256-6dXj/bdhyMTsCKJHBkE+mweKHVU3GGYrU1sahkbV+SI=";
              leaveDotGit = true;
            };
            pharo-llvmDisassembler = pkgs.fetchgit {
              url = "https://github.com/pharo-project/pharo-llvmDisassembler";
              rev = "7116291e783c0977bd08dfc936c203828e2c5b98";
              sha256 = "sha256-clwUvmYqjUXVEBz1YVPumqdwCzl2ExWpSxAMgFwrBco=";
              leaveDotGit = true;
            };
            pharoPatchTemplate = ./pharo.patch.template;
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
              git
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
              mkdir -p /build/buildDirectory/vmmaker/src
              mv ../headless /build/buildDirectory/vmmaker/vm
              cp ${bootstrap-image} /build/buildDirectory/vmmaker/src
              mv ../image /build/buildDirectory/vmmaker/image
              cp ${bootstrap-image} /build/buildDirectory/${bootstrap-image-zip}
            '';

            patchPhase = ''
              runHook prePatch
              patch -p0 -d ../repository/cmake < ${./repository_cmake_vmmaker_cmake.patch}
              patch -p0 -d ./cmake < ${./pharo-vm_cmake_vmmaker_cmake.patch}
              # mkdir -p /build/buildDirectory/vmmaker/vm
              cp ${./pharo.patch.template} /build/buildDirectory/vmmaker/vm/pharo.patch.template
              substituteInPlace /build/buildDirectory/vmmaker/vm/pharo.patch.template \
                --replace-fail "@out@" "$out"
              patch -p0 -d /build/buildDirectory/vmmaker/vm < /build/buildDirectory/vmmaker/vm/pharo.patch.template

              substituteInPlace /build/buildDirectory/vmmaker/vm/pharo \
                --replace-fail "/usr/bin/dirname" "${pkgs.coreutils}/bin/dirname" \
                --replace-fail "/usr/bin/ldd" "${pkgs.glibc.bin}/bin/ldd" \
                --replace-fail "/bin/fgrep" "${pkgs.gnugrep}/bin/fgrep" \
                --replace-fail 'LD_LIBRARY_PATH="' 'LD_LIBRARY_PATH="/build/buildDirectory/vmmaker/vm/lib:'
#                --replace-fail 'LD_LIBRARY_PATH="' 'LD_LIBRARY_PATH="$out/lib:'
              patchelf --set-interpreter ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 --add-rpath /build/buildDirectory/vmmaker/vm/lib /build/buildDirectory/vmmaker/vm/lib/pharo

              # pushd /build/buildDirectory/vmmaker/src
              # unzip zjm9mf3wwic6hmmfxxiki77m1livq217-Pharo12.0-SNAPSHOT.build.1519.sha.aa50f9c.arch.64bit.zip
              # ls -lrthila
              # exit 1
              runHook postPatch
            '';

            unusedPreConfigure = ''
              mkdir -p /build/buildDirectory/vmmaker
              touch /build/buildDirectory/vmmaker/CMakeLists.txt  # Fake it so CMake is happy
              echo "set(VMMAKER_PLACEHOLDER ON)" > /build/buildDirectory/vmmaker/CMakeLists.txt
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

              echo "Step 0"
              pushd /build/buildDirectory/vmmaker/vm/lib/
              rm -f libgit*
              ln -s ${pkgs.libgit2}/lib/libgit2.so libgit2.so
              ln -s libgit2.so libgit2.so.1.4.4
              popd
              cmake \
                --debug-output \
                -DFLAVOUR=CoInterpreter \
                -DALWAYS_INTERACTIVE=ON \
                -DGENERATE_VMMAKER=ON \
                -DGENERATE_PHARO_VM=/build/buildDirectory/vmmaker/vm/pharo \
                -DGENERATE_SOURCES=ON \
                -DVMMAKER_IMAGE=/build/buildDirectory/vmmaker/image \
                -DVMMAKER_VM=/build/buildDirectory/vmmaker/vm \
                -DBUILD_BUNDLE=ON \
                -DPHARO_DEPENDENCIES_PREFER_DOWNLOAD_BINARIES=OFF \
                -DDEPENDENCIES_FORCE_BUILD=OFF \
                -DFEATURE_LIB_GIT2=ON \
                -DFEATURE_LIB_FREETYPE2=ON \
                -DFEATURE_LIB_CAIRO=ON \
                -DFEATURE_LIB_SDL2=ON \
                 -S /build/pharo-vm -B /build/buildDirectory
              runHook postBuild
            '';

            installPhase = ''
              runHook preInstall

              echo "Step 1"
              cd /build/pharo-vm
              # mkdir -p /build/buildDirectory/build/vmmaker/image/pharo-local/package-cache \
              #          /build/buildDirectory/build/vmmaker/image/pharo-local/iceberg/guillep \
              #          /build/buildDirectory/build/vmmaker/image/pharo-local/iceberg/evref-inria \
              #          /build/buildDirectory/build/vmmaker/image/pharo-local/iceberg/pharo-project
              #cp -r ${smacc} /build/buildDirectory/build/vmmaker/image/pharo-local/iceberg/guillep/SmaCC
              #cp -r ${pharo-opal-simd-bytecode} /build/buildDirectory/build/vmmaker/image/pharo-local/iceberg/evref-inria/pharo-opal-simd-bytecode
              #cp -r ${pharo-unicorn}/src /build/buildDirectory/build/vmmaker/image/pharo-local/iceberg/pharo-project/pharo-unicorn
              #cp -r ${pharo-llvmDisassembler}/src /build/buildDirectory/build/vmmaker/image/pharo-local/iceberg/pharo-project/pharo-llvmDissassembler
              # ls /build/buildDirectory/build/vmmaker/image/pharo-local/iceberg/guillep/SmaCC # doesn't fail!
              patch -p0 -d ./smalltalksrc/BaselineOfVMMaker < ${./BaselineOfVMMaker.class.st.patch}
              substituteInPlace smalltalksrc/BaselineOfVMMaker/BaselineOfVMMaker.class.st \
                --replace-fail "SMACCSRC" "${smacc}" \
                --replace-fail "'github://guillep/SmaCC'" "'filetree://', smaccRepoDirectory fullName"
              #  --replace-fail "github://pharo-project/pharo-unicorn:unicorn2" "tonel:///build/pharo-vm/build/buildDirectory/vmmaker/image/pharo-local/iceberg/pharo-project/pharo-unicorn" \
              #  --replace-fail "github://pharo-project/pharo-llvmDisassembler" "tonel:///build/pharo-vm/build/buildDirectory/vmmaker/image/pharo-local/iceberg/pharo-project/pharo-llvmDisassembler" \
              #  --replace-fail "github://evref-inria/pharo-opal-simd-bytecode:main" "tonel:///build/pharo-vm/build/buildDirectory/vmmaker/image/pharo-local/iceberg/evref-inria/pharo-opal-simd-bytecode"

              cat smalltalksrc/BaselineOfVMMaker/BaselineOfVMMaker.class.st
              cmake --build /build/buildDirectory --target install
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
            # bootstrap-image-zip = "Pharo12.0-SNAPSHOT.build.1519.sha.aa50f9c.arch.64bit.zip";
            bootstrap-image-zip = "Pharo12.0-SNAPSHOT.build.1519.sha.aa50f9c.arch.64bit.zip";
            # bootstrap-image-url = "https://files.pharo.org/image/120/${bootstrap-image-zip}";
            bootstrap-image-url = "https://files.pharo.org/image/120/${bootstrap-image-zip}";
            # bootstrap-image-sha256 = "sha256-sSJwYx/8DGrcsLZElWW5q/2OiKhjqJSnMg9mDAWgrx4=";
            bootstrap-image-sha256 = "sha256-sSJwYx/8DGrcsLZElWW5q/2OiKhjqJSnMg9mDAWgrx4=";
          };
          pharo-vm-10 = pharo-vm-for { version = "10.3.3"; sha256 = ""; };
          pharo-vm-9 = pharo-vm-for { version = "9.0.22"; sha256 = ""; };
        };
      });
}
