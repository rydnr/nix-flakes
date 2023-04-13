{ beautifulsoup4, buildPythonPackage, feedparser, fetchPypi, importlib-metadata
, importlib-resources, jaraco-context, jaraco_functools, jaraco_itertools
, jaraco_mongodb, lib, python, python-dateutil, pytz, pyyaml, requests
, setuptools, wordnik-py3 }:

buildPythonPackage rec {
  pname = "pmxbot";
  version = "1122.14.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-PWRvXnDLQXs63NdqaKZkvruUobKx7JWpVhoF994DLJ0=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    beautifulsoup4
    feedparser
    importlib-metadata
    importlib-resources
    jaraco-context
    jaraco_functools
    jaraco_itertools
    jaraco_mongodb
    python-dateutil
    pytz
    pyyaml
    requests
    wordnik-py3
  ];

  meta = with lib; {
    description = "pmxbot is bot for IRC and Slack written in Python.";
    license = licenses.mit;
    homepage = "https://github.com/pmxbot/pmxbot";
    maintainers = with maintainers; [ ];
  };
}
