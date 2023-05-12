{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "opentelemetry-instrumentation-aiohttp-client";
  version = "0.38b0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "093987f5c96518ac6999eb7480af168655bc3538752ae67d4d9a5807eaad1ee0";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
OpenTelemetry aiohttp client Integration
========================================

|pypi|

.. |pypi| image:: https://badge.fury.io/py/opentelemetry-instrumentation-aiohttp-client.svg
   :target: https://pypi.org/project/opentelemetry-instrumentation-aiohttp-client/

This library allows tracing HTTP requests made by the
`aiohttp client <https://docs.aiohttp.org/en/stable/client.html>`_ library.

Installation
------------

::

     pip install opentelemetry-instrumentation-aiohttp-client

References
----------

* `OpenTelemetry Project <https://opentelemetry.io/>`_
* `aiohttp client Tracing <https://docs.aiohttp.org/en/stable/tracing_reference.html>`_
* `OpenTelemetry Python Examples <https://github.com/open-telemetry/opentelemetry-python/tree/main/docs/examples>`_

'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}
