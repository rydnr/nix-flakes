{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "opentelemetry-exporter-otlp";
  version = "1.17.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9708d2b74c9205a7bd9b46e24acec0e3b362465d9a77b62347ea0459d4358044";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
OpenTelemetry Collector Exporters
=================================

|pypi|

.. |pypi| image:: https://badge.fury.io/py/opentelemetry-exporter-otlp.svg
   :target: https://pypi.org/project/opentelemetry-exporter-otlp/

This library is provided as a convenience to install all supported OpenTelemetry Collector Exporters. Currently it installs:

* opentelemetry-exporter-otlp-proto-grpc
* opentelemetry-exporter-otlp-proto-http

In the future, additional packages will be available:
* opentelemetry-exporter-otlp-json-http

To avoid unnecessary dependencies, users should install the specific package once they've determined their
preferred serialization and protocol method.

Installation
------------

::

     pip install opentelemetry-exporter-otlp


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
