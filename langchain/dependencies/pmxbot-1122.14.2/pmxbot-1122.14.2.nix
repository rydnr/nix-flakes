{ buildPythonApplication, fetchFromGitHub, lib, stdenv }:

buildPythonApplication rec {
  pname = "pmxbot";
  version = "1122.14.2";

  src = fetchFromGitHub {
    owner = "pmxbot";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-WUJsuA9yFIxckMDhNl10zBUeqdZRK46jT+GSNqOJVnQ=";
  };

  pythonImportsCheck = [ "pmxbot" ];

  meta = with lib; {
    description = "pmxbot is bot for IRC and Slack written in Python.";
    license = licenses.mit;
    homepage = "https://github.com/pmxbot/pmxbot";
    maintainers = with maintainers; [ ];
  };
}
