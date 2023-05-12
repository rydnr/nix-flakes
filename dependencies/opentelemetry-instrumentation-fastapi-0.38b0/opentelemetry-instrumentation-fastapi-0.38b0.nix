{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "opentelemetry-instrumentation-fastapi";
  version = "0.38b0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "91139586732e437b1c3d5cf838dc5be910bce27b4b679612112be03fcc4fa2aa";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
OpenTelemetry FastAPI Instrumentation
=======================================

|pypi|

.. |pypi| image:: https://badge.fury.io/py/opentelemetry-instrumentation-fastapi.svg
   :target: https://pypi.org/project/opentelemetry-instrumentation-fastapi/


This library provides automatic and manual instrumentation of FastAPI web frameworks,
instrumenting http requests served by applications utilizing the framework.

auto-instrumentation using the opentelemetry-instrumentation package is also supported.

Installation
------------

::

    pip install opentelemetry-instrumentation-fastapi

References
----------

* `OpenTelemetry Project <https://opentelemetry.io/>`_
* `OpenTelemetry Python Examples <https://github.com/open-telemetry/opentelemetry-python/tree/main/docs/examples>`_

'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}
