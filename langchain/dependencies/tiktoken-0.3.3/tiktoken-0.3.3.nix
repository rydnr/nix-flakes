{ lib, buildPythonPackage, fetchFromGitHub, regex, requests, semantic-version
, setuptools-rust, tiktoken-rust, typing-extensions }:

buildPythonPackage rec {
  pname = "tiktoken";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "openai";
    repo = pname;
    rev = version;
    hash = "sha256-5YucJjoYAUTRy7oJ3yb2uE1UZDLIPXnV0bJIDgwGOeA=";
  };

  prePatch = ''
    cp ${./setup.py} setup.py
    cp ${tiktoken-rust.out}/lib/lib_tiktoken.so tiktoken/_tiktoken.so
    substituteInPlace setup.py \
          --replace "path/to/your/prebuilt/rust/extension" "${tiktoken-rust.out}/lib"
    cat setup.py
  '';

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'rust_extensions=[' 'rust_extensions_disabled=['
  '';

  # Set the LIBRARY_PATH and LD_LIBRARY_PATH environment variables
  preBuild = ''
    export LIBRARY_PATH="${tiktoken-rust.out}/lib:$LIBRARY_PATH"
    export LD_LIBRARY_PATH="${tiktoken-rust.out}/lib:$LD_LIBRARY_PATH"
  '';

  nativeBuildInputs = [ setuptools-rust ];
  propagatedBuildInputs =
    [ regex requests semantic-version tiktoken-rust typing-extensions ];

  meta = with lib; {
    description = "Fast BPE tokeniser for use with OpenAI's models.";
    homepage = "https://github.com/openai/tiktoken";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
