{ blobfile, bstr-src, buildPythonPackage, cargo, cargo2nix, fancy-regex-src
, fetchFromGitHub, lib, regex, requests, rustc, rustBuilder, rustPlatform
, rustPkgs, semantic-version, setuptools-rust, typing-extensions }:

let
  tiktoken-src = {
    url = "github:openai/tiktoken?rev=0.3.3";
    flake = false;
  };

  rustPackages = import ./Cargo.nix {
    inherit (rustPlatform) cargo fetchCargoTarball;
    inherit lib;
    workspaceSrc = fetchFromGitHub {
      owner = "openai";
      repo = "tiktoken";
      rev = "0.3.3";
      hash = "sha256-5YucJjoYAUTRy7oJ3yb2uE1UZDLIPXnV0bJIDgwGOeA=";
    };
  };

  tiktoken-rust = rustPackages.workspace.tiktoken { };
in buildPythonPackage rec {
  pname = "tiktoken";
  version = "0.3.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "openai";
    repo = pname;
    rev = version;
    hash = "sha256-5YucJjoYAUTRy7oJ3yb2uE1UZDLIPXnV0bJIDgwGOeA=";
  };

  nativeBuildInputs = [ cargo rustc setuptools-rust ];
  #  propagatedBuildInputs = map (f: f { }.bin) (builtins.attrValues
  #    (builtins.filter (entry: builtins.hasPrefix "registry+" entry.key)
  #      (builtins.toList rustPkgs)));
  propagatedBuildInputs =
    [ blobfile regex requests semantic-version typing-extensions ] ++ [
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".aho-corasick."0.7.20"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".autocfg."1.1.0"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".bit-set."0.5.3"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".bit-vec."0.6.3"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".bitflags."1.3.2"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".bstr."1.4.0"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".cfg-if."1.0.0"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".fancy-regex."0.10.0"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".indoc."1.0.9"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".libc."0.2.141"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".lock_api."0.4.9"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".memchr."2.5.0"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".memoffset."0.6.5"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".once_cell."1.17.1"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".parking_lot."0.12.1"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".parking_lot_core."0.9.7"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".proc-macro2."1.0.56"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".pyo3."0.17.3"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".pyo3-build-config."0.17.3"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".pyo3-ffi."0.17.3"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".pyo3-macros."0.17.3"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".pyo3-macros-backend."0.17.3"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".quote."1.0.26"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".redox_syscall."0.2.16"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".regex."1.7.3"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".regex-automata."0.1.10"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".regex-syntax."0.6.29"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".rustc-hash."1.1.0"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".scopeguard."1.1.0"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".serde."1.0.159"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".smallvec."1.10.0"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".syn."1.0.109"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".target-lexicon."0.12.6"
        { }).bin
      (rustPkgs."unknown".tiktoken."0.3.3" { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".unicode-ident."1.0.8"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".unindent."0.1.11"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".windows-sys."0.45.0"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".windows-targets."0.42.2"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".windows_aarch64_gnullvm."0.42.2"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".windows_aarch64_msvc."0.42.2"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".windows_i686_gnu."0.42.2"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".windows_i686_msvc."0.42.2"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".windows_x86_64_gnu."0.42.2"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".windows_x86_64_gnullvm."0.42.2"
        { }).bin
      (rustPkgs."registry+https://github.com/rust-lang/crates.io-index".windows_x86_64_msvc."0.42.2"
        { }).bin
    ];

  buildPhase = ''
    export CARGO_HOME=$(pwd)/.cargo
    mkdir $CARGO_HOME
    echo '[net]' >> $(pwd)/.cargo/config
    echo 'offline = true' >> $(pwd)/.cargo/config
    cat $(pwd)/.cargo/config
    runHook preBuild
    echo "PATH: $PATH"
    echo "NIX_BUILD_TOP: $NIX_BUILD_TOP"
    cargo build --release
    python setup.py build
    runHook postBuild
  '';

  #  doBuild = false;

  meta = with lib; {
    description = "Fast BPE tokeniser for use with OpenAI's models.";
    homepage = "https://github.com/openai/tiktoken";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
