{ blobfile, buildPythonPackage, cargo, cargo2nix, fetchPypi, lib, regex
, requests, rustc, semantic-version, setuptools-rust, typing-extensions }:

buildPythonPackage rec {
  pname = "tiktoken";
  version = "0.3.3";
  format = "setuptools";

  src = let
    src_ = fetchPypi {
      inherit pname version;
      hash = "sha256-l7WLe/2pRXkeyFXlPRZujsIMY3iUK5OFGmyRnd+dBJY=";
    };
  in src_ // { sourceRoot = "${src_.out}/source"; };

  nativeBuildInputs = [ cargo rustc ];
  propagatedBuildInputs = [
    blobfile
    regex
    requests
    semantic-version
    setuptools-rust
    typing-extensions
  ];

  # Add Rust dependencies from Cargo.nix
  rustDeps = import ./Cargo.nix {
    inherit (cargo2nix)
      rustPackages buildRustPackages hostPlatform hostPlatformCpu
      hostPlatformFeatures target codegenOpts profileOpts rustcLinkFlags
      rustcBuildFlags mkRustCrate rustLib lib;
    workspaceSrc = src.sourceRoot;
  };

  meta = with lib; {
    description = "Fast BPE tokeniser for use with OpenAI's models.";
    homepage = "https://github.com/openai/tiktoken";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
