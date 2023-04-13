{ buildPythonPackage, fetchPypi, jaraco_collections, jaraco_itertools
, jaraco_logging, jaraco_services, jaraco_ui, lib, pymongo, python
, python-dateutil, pytimeparse, setuptools, setuptools-scm }:

buildPythonPackage rec {
  pname = "jaraco.mongodb";
  version = "11.2.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-a24xfOwDMhAdcvKnJy/1FR3EJxdTw5QjqO/zUEap4Ak=";
  };

  pythonNamespaces = [ "jaraco" ];

  nativeBuildInputs = [ setuptools setuptools-scm ];

  propagatedBuildInputs = [
    jaraco_collections
    jaraco_itertools
    jaraco_logging
    jaraco_services
    jaraco_ui
    pymongo
    python-dateutil
    pytimeparse
  ];

  meta = with lib; {
    description =
      "This package provides an oplog module, which is based on the mongooplog-alt project, which itself is a Python remake of official mongooplog utility, shipped with MongoDB starting from version 2.2 and deprecated in 3.2.";
    license = licenses.mit;
    homepage = "https://github.com/jaraco/jaraco.mongodb";
    maintainers = with maintainers; [ ];
  };
}
