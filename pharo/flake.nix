{
  description = "Flake for Pharo";

  inputs = rec {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.11";
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pname = "pharo";
        version = "10.3.1-6cd1e5";
        url = "https://files.pharo.org/vm/pharo-spur64-headless/Linux-x86_64/source/PharoVM-${version}-Linux-x86_64-c-src.zip";
        hash = "sha256-Oskbo0ZMh2Wr8uY9BjA54AhFVDEuzs4AN8cpO02gdfY=";
        pkgs = import nixpkgs { inherit system; };
        description = "Pharo VM";
        license = pkgs.lib.licenses.mit;
        homepage = "https://pharo.org";
        maintainers = with pkgs.lib.maintainers; [ ];
        nixpkgsVersion = builtins.readFile "${nixpkgs}/.version";
        nixpkgsRelease =
          builtins.replaceStrings [ "\n" ] [ "" ] "nixpkgs-${nixpkgsVersion}";
        shared = import ../shared.nix;
        pharo = stdenv.mkDerivation (finalAttrs: {
            inherit pname version;
            src = fetchzip {
              inherit url hash;
            };

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

            nativeBuildInputs = [
              cmake
              makeBinaryWrapper
            ];

            cmakeFlags = [
              # Necessary to perform the bootstrapping without already having Pharo available.
              "-DGENERATED_SOURCE_DIR=."
              "-DALWAYS_INTERACTIVE=ON"
              "-DBUILD_IS_RELEASE=ON"
              "-DGENERATE_SOURCES=OFF"
              # Prevents CMake from trying to download stuff.
              "-DBUILD_BUNDLE=OFF"
            ];

            env.NIX_CFLAGS_COMPILE = toString [
              "-Wno-incompatible-pointer-types"
            ];

            installPhase = ''
                runHook preInstall

                cmake --build . --target=install
                mkdir -p "$out/lib"
                mkdir "$out/bin"
                cp build/vm/*.so* "$out/lib/"
                cp build/vm/pharo "$out/bin/pharo"

                runHook postInstall
             '';

            preFixup =
              let
                libPath = lib.makeLibraryPath (
                  finalAttrs.buildInputs
                  ++ [
                    stdenv.cc.cc
                    "$out"
                  ]
                );
              in
                ''
                patchelf --allowed-rpath-prefixes "$NIX_STORE" --shrink-rpath "$out/bin/pharo"
                ln -s "${libgit2}/lib/libgit2.so" $out/lib/libgit2.so.1.1
                wrapProgram "$out/bin/pharo" --argv0 $out/bin/pharo --prefix LD_LIBRARY_PATH ":" "${libPath}"
                '';

            meta = {
              description = "Clean and innovative Smalltalk-inspired environment";
              homepage = "https://pharo.org";
              changelog = "https://github.com/pharo-project/pharo/releases/";
              license = lib.licenses.mit;
              longDescription = ''
                    Pharo's goal is to deliver a clean, innovative, free open-source
                    Smalltalk-inspired environment. By providing a stable and small core
                    system, excellent dev tools, and maintained releases, Pharo is an
                    attractive platform to build and deploy mission critical applications.
              '';
              maintainers = with lib.maintainers; [ ehmry ];
              mainProgram = "pharo";
              platforms = lib.platforms.linux;
            };

      in rec {
        defaultPackage = packages.default;
        devShells = rec {
          default = pharo;
          pharo = shared.devShell-for {
            package = packages.pharo;
            inherit pkgs nixpkgsRelease;
          };
        };
        packages = rec {
          default = pharo;
          pharo = pharo;
        };
      });
}
