{ lib, buildPythonPackage, fetchPypi, pythonOlder, semantic-version
, typing-extensions }:

buildPythonPackage rec {
  pname = "setuptools-rust";
  version = "1.5.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2NrMsU3A6uG2tus+zveWdb03tAZTafecNTk91cVWUsc=";
  };

  buildInputs = [ semantic-version typing-extensions ];

  meta = with lib; {
    description =
      "plugin for setuptools to build Rust Python extensions implemented with PyO3 or rust-cpython";
    homepage = "https://github.com/PyO3/setuptools-rust";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
