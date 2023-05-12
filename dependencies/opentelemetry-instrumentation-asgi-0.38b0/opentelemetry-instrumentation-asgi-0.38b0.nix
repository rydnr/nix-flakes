{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "opentelemetry-instrumentation-asgi";
  version = "0.38b0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c5bba11505008a3cd1b2c42b72f85f3f4f5af50ab931eddd0b01bde376dc5971";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
OpenTelemetry ASGI Instrumentation
==================================

|pypi|

.. |pypi| image:: https://badge.fury.io/py/opentelemetry-instrumentation-asgi.svg
   :target: https://pypi.org/project/opentelemetry-instrumentation-asgi/


This library provides a ASGI middleware that can be used on any ASGI framework
(such as Django, Starlette, FastAPI or Quart) to track requests timing through OpenTelemetry.

Installation
------------

::

    pip install opentelemetry-instrumentation-asgi

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
