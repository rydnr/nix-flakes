{ lib, buildPythonPackage, fetchFromGitHub, astor }:

buildPythonPackage rec {
  pname = "blobfile";
  version = "2.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "christopher-hesse";
    repo = "blobfile";
    rev = "v${version}";
    sha256 = "sha256-EUU/ZORqri3EIUUAho6cNdRgH+we13AgHyTjsY6tCWg=";
  };

  nativeBuildInputs = [ astor ];

  meta = with lib; {
    description = "Python-like interface for reading local and remote files.";
    homepage = "https://github.com/christopher-hesse/blobfile";
    license = licenses.unlicense;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
