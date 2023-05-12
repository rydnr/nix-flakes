{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "opentelemetry-sdk";
  version = "1.17.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07424cbcc8c012bc120ed573d5443e7322f3fb393512e72866c30111070a8c37";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
OpenTelemetry Python SDK
============================================================================

|pypi|

.. |pypi| image:: https://badge.fury.io/py/opentelemetry-sdk.svg
   :target: https://pypi.org/project/opentelemetry-sdk/

Installation
------------

::

    pip install opentelemetry-sdk

References
----------

* `OpenTelemetry Project <https://opentelemetry.io/>`_

'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}
