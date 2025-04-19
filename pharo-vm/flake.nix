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
        version = "12.0.1519.4";
        sha256 = "sha256-0FE39wsZt8P/oimBxrPMC+bIJdLJPInavJH1R2d3mpU=";
        commit = "2a0a66393d627d95f064fefa4aba576004452e01";
        pkgs = import nixpkgs { inherit system; };
        description = "Pharo VM";
        license = pkgs.lib.licenses.mit;
        homepage = "https://pharo.org";
        maintainers = with pkgs.lib.maintainers; [ ehmry ];
        nixpkgsVersion = builtins.readFile "${nixpkgs}/.version";
        nixpkgsRelease =
          builtins.replaceStrings [ "\n" ] [ "" ] "nixpkgs-${nixpkgsVersion}";
        shared = import ../shared.nix;
        bootstrap-image-zip = "Pharo12.0-SNAPSHOT.build.1519.sha.aa50f9c.arch.64bit.zip";
        bootstrap-image-url = "https://files.pharo.org/image/120/${bootstrap-image-zip}";
        bootstrap-image-sha256 = "sha256-sSJwYx/8DGrcsLZElWW5q/2OiKhjqJSnMg9mDAWgrx4=";
        bootstrap-image-name = "Pharo12.0-SNAPSHOT-64bit-aa50f9c.image"; # unzip ${bootstrap-image-zip} to find out he image name.
        pharoVMParams =
          if system == "x86_64-linux" then rec {
            c-sources-zip = "PharoVM-10.2.1-d417aeb-Linux-x86_64-c-src.zip";
            c-sources-url = "https://files.pharo.org/vm/pharo-spur64-headless/Linux-x86_64/source/${c-sources-zip}";
            c-sources-sha256 = "sha256-gbDhV1Y04GZvdlYLXEQBlnnewoXnPoGah5DmInEvKXI=";

            headless-bin-zip = "PharoVM-10.3.1-6cdb1e5-Linux-x86_64-bin.zip";
            headless-bin-url = "https://files.pharo.org/vm/pharo-spur64-headless/Linux-x86_64/${headless-bin-zip}";
            headless-bin-sha256 = "sha256-oS+VX1U//tTWabTbpvTBbowJQ0YlPY8+vR/jd+Up+lU=";

            inherit bootstrap-image-url bootstrap-image-zip bootstrap-image-sha256;
          } else if system == "x86_64-darwin" then rec {
            c-sources-zip = "PharoVM-v12.0.1-alpha%2B4.e9d1d652-Darwin-x86_64-c-src.zip";
            c-sources-url = "https://files.pharo.org/vm/pharo-spur64-headless/Darwin-x86_64/source/${c-sources-zip}";
            c-sources-sha256 = "";

            headless-bin-zip = "PharoVM-v12.0.1-alpha%2B4.e9d1d652-Darwin-x86_64-StackVM-bin.zip";
            headless-bin-url = "https://files.pharo.org/vm/pharo-spur64-headless/Darwin-x86_64/${headless-bin-zip}";
            headless-bin-sha256 = "";

            inherit bootstrap-image-url bootstrap-image-zip bootstrap-image-sha256;
          } else if system == "aarch-linux" then rec {
            c-sources-zip = "PharoVM-9.0.9-d910e1d-d910e1d-Linux-aarch64-c-src.zip";
            c-sources-url = "https://files.pharo.org/vm/pharo-spur64-headless/Linux-aarch64/source/${c-sources-zip}";
            c-sources-sha256 = "";

            headless-bin-zip = "PharoVM-9.0.9-d910e1d-d910e1d-Linux-aarch64-bin.zip";
            headless-bin-url = "https://files.pharo.org/vm/pharo-spur64-headless/Linux-aarch64/${headless-bin-zip}";
            headless-bin-sha256 = "";

            inherit bootstrap-image-url bootstrap-image-zip bootstrap-image-sha256;
          } else throw "Unsupported system: ${system}";
        pharo-vm-for = { c-sources-url, c-sources-zip, c-sources-sha256, headless-bin-url, headless-bin-zip, headless-bin-sha256, bootstrap-image-url, bootstrap-image-zip, bootstrap-image-sha256 }:
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
            isDarwin = pkgs.stdenv.isDarwin;
            libuuidRpath = if isDarwin then "" else "${pkgs.libuuid.lib}/lib";
            pharoVmCmakeVmmakerCmakePatch = pkgs.substituteAll {
              bootstrapImageZip = bootstrap-image-zip;
              src = ./patches/pharo-vm/cmake/vmmaker.cmake.patch.template;
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
              done
              mkdir -p /build/buildDirectory/vmmaker/src
              mv ../headless /build/buildDirectory/vmmaker/vm
              cp ${bootstrap-image} /build/buildDirectory/vmmaker/src
              mv ../image /build/buildDirectory/vmmaker/image
              cp ${bootstrap-image} /build/buildDirectory/${bootstrap-image-zip}
            '';

            patchPhase = ''
              runHook prePatch
              patch -p0 -d ./cmake < ${pharoVmCmakeVmmakerCmakePatch}
              cp ${./patches/pharo.patch.template} /build/buildDirectory/vmmaker/vm/pharo.patch.template
              substituteInPlace /build/buildDirectory/vmmaker/vm/pharo.patch.template \
                --replace-fail "@libffi@" "${pkgs.libffi}" \
                --replace-fail "@cairo@" "${pkgs.cairo}" \
                --replace-fail "@freetype@" "${pkgs.freetype}" \
                --replace-fail "@libgit2@" "${pkgs.libgit2}" \
                --replace-fail "@libpng@" "${pkgs.libpng}" \
                --replace-fail "@libuuid@" "${libuuidRpath}" \
                --replace-fail "@openssl@" "${pkgs.openssl.out}" \
                --replace-fail "@pixman@" "${pkgs.pixman}" \
                --replace-fail "@sdl2@" "${pkgs.SDL2}" \
                --replace-fail "@harfbuzz@" "${pkgs.harfbuzz}" \
                --replace-fail "@out@" "$(realpath "$out")"
              patch -p0 -d /build/buildDirectory/vmmaker/vm < /build/buildDirectory/vmmaker/vm/pharo.patch.template
              substituteInPlace /build/buildDirectory/vmmaker/vm/pharo \
                --replace-fail "/usr/bin/dirname" "${pkgs.coreutils}/bin/dirname" \
                --replace-fail "/usr/bin/ldd" "${pkgs.glibc.bin}/bin/ldd" \
                --replace-fail "/bin/fgrep" "${pkgs.gnugrep}/bin/fgrep"
              patchelf --set-interpreter ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 --add-rpath /build/buildDirectory/vmmaker/vm/lib /build/buildDirectory/vmmaker/vm/lib/pharo

              runHook postPatch
            '';

            configurePhase = ''
              runHook preConfigure

              echo "${version}" > version.info
              echo "${version}-${commit}" >> version.info
              date '+%Y-%m-%d' >> version.info

              runHook postConfigure
              '';

            buildPhase = ''
              runHook preBuild

              pushd /build/buildDirectory/vmmaker/vm/lib/
              rm -f libgit*
              ln -s ${pkgs.libgit2}/lib/libgit2.so libgit2.so
              ln -s libgit2.so libgit2.so.1.4.4
              popd
              pushd /build/pharo-vm
              cmake \
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

              patch -p0 -d ./smalltalksrc/BaselineOfVMMaker < ${./patches/BaselineOfVMMaker.class.st.patch}
              substituteInPlace smalltalksrc/BaselineOfVMMaker/BaselineOfVMMaker.class.st \
                --replace-fail "github://guillep/SmaCC" "filetree://${smacc}" \
                --replace-fail "github://pharo-project/pharo-unicorn:unicorn2" "tonel://${pharo-unicorn}/src" \
                --replace-fail "github://pharo-project/pharo-llvmDisassembler" "tonel://${pharo-llvmDisassembler}/src" \
                --replace-fail "github://evref-inria/pharo-opal-simd-bytecode:main" "tonel://${pharo-opal-simd-bytecode}"

              cmake --build /build/buildDirectory --target install
              popd

              patch -p0 -d /build/buildDirectory/build/dist/bin < /build/buildDirectory/vmmaker/vm/pharo.patch.template
              substituteInPlace /build/buildDirectory/build/dist/bin/pharo \
                --replace-fail "/usr/bin/dirname" "${pkgs.coreutils}/bin/dirname" \
                --replace-fail "/usr/bin/ldd" "${pkgs.glibc.bin}/bin/ldd" \
                --replace-fail "/bin/fgrep" "${pkgs.gnugrep}/bin/fgrep" \
                --replace-fail " grep " " ${pkgs.gnugrep}/bin/grep " \
                --replace-fail " sed " " ${pkgs.gnused}/bin/sed " \
                --replace-fail "uname" "${pkgs.coreutils}/bin/uname" \
                --replace-fail "gdb" "${pkgs.gdb}/bin/gdb"
              patchelf --remove-rpath /build/buildDirectory/build/dist/lib/pharo

              patchelf \
                --set-interpreter ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 \
                --add-rpath $(realpath $out)/lib:${pkgs.lib.concatStringsSep ":" (pkgs.lib.filter (s: s != "") [
                  "${pkgs.libffi}/lib"
                  "${pkgs.cairo}/lib"
                  "${pkgs.freetype}/lib"
                  "${pkgs.libgit2}/lib"
                  "${pkgs.libpng}/lib"
                  "${libuuidRpath}"
                  "${pkgs.openssl.out}/lib"
                  "${pkgs.pixman}/lib"
                  "${pkgs.SDL2}/lib"
                  "${pkgs.harfbuzz}/lib"
                ])} /build/buildDirectory/build/dist/lib/pharo
              rm -f /build/buildDirectory/build/dist/pharo
              runHook postBuild
            '';

            installPhase = ''
              runHook preInstall

              mkdir -p $out
              cp -r /build/buildDirectory/build/dist/lib $out/
              cp -r /build/buildDirectory/build/dist/bin $out/
              cp -r /build/buildDirectory/build/dist/include $out/
              pushd $out/lib
              for dep in "${pkgs.libffi}/lib/libffi.so" \
                         "${pkgs.cairo}/lib/libcairo.so" \
                         "${pkgs.freetype}/lib/libfreetype.so" \
                         "${pkgs.libgit2}/lib/libgit2.so" \
                         "${pkgs.libpng}/lib/libpng.so" \
                         "${libuuidRpath}/libuuid.so" \
                         "${pkgs.openssl.out}/lib/libcrypto.so" \
                         "${pkgs.pixman}/lib/libpixman-1.so" \
                         "${pkgs.SDL2}/lib/libSDL2.so"; do \
                ln -s $dep .
              done
              ln -s libgit2.so libgit2.so.1.4.4
              popd
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
          default = pharo-vm;
          pharo-vm = shared.devShell-for {
            package = packages.pharo-vm;
            python = pkgs.python3;
            inherit pkgs nixpkgsRelease;
          };
        };
        packages = rec {
          default = pharo-vm;
          pharo-vm = pharo-vm-for pharoVMParams;
        };
        resources = {
          inherit c-sources-zip c-sources-url c-sources-sha256;
          inherit headless-bin-zip headless-bin-url headless-bin-sha256;
          inherit bootstrap-image-zip bootstrap-image-url bootstrap-image-sha256 bootstrap-image-name;
        };
      });
}
