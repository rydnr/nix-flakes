{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "opentelemetry-api";
  version = "1.17.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b41d9b2a979607b75d2683b9bbf97062a683d190bc696969fb2122fa60aeaabc";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
OpenTelemetry Python API
============================================================================

|pypi|

.. |pypi| image:: https://badge.fury.io/py/opentelemetry-api.svg
   :target: https://pypi.org/project/opentelemetry-api/

Installation
------------

::

    pip install opentelemetry-api

References
----------

* `OpenTelemetry Project <https://opentelemetry.io/>`_

'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}
