{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "opentelemetry-exporter-otlp-proto-http";
  version = "1.17.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "81959249b75bd36c3b73c885a9ce36aa21e8022618e8e95fa41ae69609f0c799";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
OpenTelemetry Collector Protobuf over HTTP Exporter
===================================================

|pypi|

.. |pypi| image:: https://badge.fury.io/py/opentelemetry-exporter-otlp-proto-http.svg
   :target: https://pypi.org/project/opentelemetry-exporter-otlp-proto-http/

This library allows to export data to the OpenTelemetry Collector using the OpenTelemetry Protocol using Protobuf over HTTP.

Installation
------------

::

     pip install opentelemetry-exporter-otlp-proto-http


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
