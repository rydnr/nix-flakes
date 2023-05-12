{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "opentelemetry-exporter-prometheus";
  version = "1.12.0rc1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f0c8f93d62e1575313966ceb8abf11e9a46e1839fda9ee4269b06d40494280f";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
OpenTelemetry Prometheus Exporter
=================================

|pypi|

.. |pypi| image:: https://badge.fury.io/py/opentelemetry-exporter-prometheus.svg
   :target: https://pypi.org/project/opentelemetry-exporter-prometheus/

This library allows to export metrics data to `Prometheus <https://prometheus.io/>`_.

Installation
------------

::

     pip install opentelemetry-exporter-prometheus

References
----------

* `OpenTelemetry Prometheus Exporter <https://opentelemetry-python.readthedocs.io/en/latest/exporter/prometheus/prometheus.html>`_
* `Prometheus <https://prometheus.io/>`_
* `OpenTelemetry Project <https://opentelemetry.io/>`_

'';
    license = licenses.asl20;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}
