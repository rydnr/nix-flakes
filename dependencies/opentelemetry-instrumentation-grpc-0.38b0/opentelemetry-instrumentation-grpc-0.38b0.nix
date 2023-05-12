{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "opentelemetry-instrumentation-grpc";
  version = "0.38b0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "64978d158f233c45df809d927f62a79e0bbb1c433d63ae5f7b38133a515397d8";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
OpenTelemetry gRPC Integration
==============================

|pypi|

.. |pypi| image:: https://badge.fury.io/py/opentelemetry-instrumentation-grpc.svg
   :target: https://pypi.org/project/opentelemetry-instrumentation-grpc/

Client and server interceptors for `gRPC Python`_.

.. _gRPC Python: https://grpc.github.io/grpc/python/grpc.html

Installation
------------

::

     pip install opentelemetry-instrumentation-grpc


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
