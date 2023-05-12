{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "opentelemetry-exporter-otlp-proto-grpc";
  version = "1.17.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "192d781b668a74edb49152b8b5f4f7e25bcb4307a9cf4b2dfcf87e68feac98bd";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
OpenTelemetry Collector Protobuf over gRPC Exporter
===================================================

|pypi|

.. |pypi| image:: https://badge.fury.io/py/opentelemetry-exporter-otlp-proto-grpc.svg
   :target: https://pypi.org/project/opentelemetry-exporter-otlp-proto-grpc/

This library allows to export data to the OpenTelemetry Collector using the OpenTelemetry Protocol using Protobuf over gRPC.

Installation
------------

::

     pip install opentelemetry-exporter-otlp-proto-grpc


References
----------

* `OpenTelemetry Collector Exporter <https://opentelemetry-python.readthedocs.io/en/latest/exporter/otlp/otlp.html>`_
* `OpenTelemetry Collector <https://github.com/open-telemetry/opentelemetry-collector/>`_
* `OpenTelemetry <https://opentelemetry.io/>`_
* `OpenTelemetry Protocol Specification <https://github.com/open-telemetry/oteps/blob/main/text/0035-opentelemetry-protocol.md>`_

'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}
